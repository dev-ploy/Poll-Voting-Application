import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Poll } from './poll.models';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PollService {
  private baseUrl = environment.apiUrl;
  constructor(private http:HttpClient) { }

  createPoll(poll:Poll):Observable<Poll>{
    // Remove the id field before sending to avoid backend issues
    // Backend expects null/undefined for new entities, not 0
    const { id, ...pollWithoutId } = poll;
    return this.http.post<Poll>(this.baseUrl, pollWithoutId);
  }
  getPolls():Observable<Poll[]>{
    return this.http.get<Poll[]>(this.baseUrl);
}
vote(pollId:number,optionIndex:number):Observable<void>{
  const url=`${this.baseUrl}/vote`;
  return this.http.post<void>(url,{pollId,optionIndex});
}
}
