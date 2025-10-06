import { Component, signal } from '@angular/core';
// import { RouterOutlet } from '@angular/router';
import { PollComponent } from './poll/poll.component';

@Component({
  selector: 'app-root',
  standalone:true,
  imports: [PollComponent],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('poll-app');
}
