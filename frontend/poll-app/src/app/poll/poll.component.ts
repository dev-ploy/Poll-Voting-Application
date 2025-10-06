import { Component } from '@angular/core';
import { PollService } from '../poll.service';
import { Poll } from '../poll.models';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
@Component({
  selector: 'app-poll',
  imports: [CommonModule,FormsModule],
  templateUrl: './poll.component.html',
  styleUrl: './poll.component.css'
})
export class PollComponent {
  newPoll:Poll={
    id:0,
    question:'',
    options:[
      {optionText:'',voteCount:0},
      {optionText:'',voteCount:0},
    ]
  }
  polls:Poll[]=[];
  isLoading: boolean = false;
  isCreating: boolean = false;
  errorMessage: string = '';
  successMessage: string = '';
  votingPollId: number | null = null;
  
  constructor(private pollService:PollService){
    
  }
  ngOnInit():void{
    this.loadPolls();
  }
  loadPolls(){
    this.isLoading = true;
    this.errorMessage = '';
    this.pollService.getPolls().subscribe({
      next:(data)=>{
        this.polls=data;
        this.isLoading = false;
      },
      error:(error)=>{
        console.error('Error fetching polls:',error);
        this.errorMessage = 'Failed to load polls. Please refresh the page.';
        this.isLoading = false;
      }
    }
);
}
createPoll(){
  // Validate form
  if (!this.newPoll.question.trim()) {
    this.showError('Please enter a poll question.');
    return;
  }
  
  const validOptions = this.newPoll.options.filter(opt => opt.optionText.trim());
  if (validOptions.length < 2) {
    this.showError('Please provide at least 2 options.');
    return;
  }
  
  this.isCreating = true;
  this.errorMessage = '';
  
  // Filter out empty options before sending
  const pollToCreate = {
    ...this.newPoll,
    options: validOptions
  };
  
  this.pollService.createPoll(pollToCreate).subscribe({
    next:(createdPoll)=>{
      this.polls.unshift(createdPoll);
      this.resetPolls();
      this.showSuccess('Poll created successfully!');
      this.isCreating = false;
    },
    error:(error)=>{
      console.error('Error creating poll:',error);
      this.showError('Failed to create poll. The server encountered an error. Please try again.');
      this.isCreating = false;
    }
});
}
resetPolls(){
  this.newPoll={
    id:0,
    question:'',
    options:[
      {optionText:'',voteCount:0},
      {optionText:'',voteCount:0},
    ]
  };
}
vote(pollId:number,optionIndex:number){
  if (this.votingPollId === pollId) {
    return; // Prevent double voting
  }
  
  this.votingPollId = pollId;
  this.errorMessage = '';
  
  this.pollService.vote(pollId,optionIndex).subscribe({
    next:()=>{
      const poll=this.polls.find(p=>p.id===pollId);
      if(poll){
        poll.options[optionIndex].voteCount++;
      }
      this.showSuccess('Vote recorded successfully!');
      this.votingPollId = null;
    },
    error:(error)=>{
      console.error('Error voting on a poll:',error);
      this.showError('Failed to record vote. Please try again.');
      this.votingPollId = null;
    }
  });
}
addOption(){
  this.newPoll.options.push({optionText:'',voteCount:0});
}

removeOption(index: number) {
  if (this.newPoll.options.length > 2) {
    this.newPoll.options.splice(index, 1);
  }
}

trackByIndex(index:number):number{
  return index;
}

trackByPollId(index: number, poll: Poll): number {
  return poll.id;
}

showError(message: string) {
  this.errorMessage = message;
  this.successMessage = '';
  setTimeout(() => {
    this.errorMessage = '';
  }, 5000);
}

showSuccess(message: string) {
  this.successMessage = message;
  this.errorMessage = '';
  setTimeout(() => {
    this.successMessage = '';
  }, 3000);
}

getTotalVotes(poll: Poll): number {
  return poll.options.reduce((total, option) => total + option.voteCount, 0);
}
}
