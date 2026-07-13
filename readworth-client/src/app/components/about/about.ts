import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-about',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './about.html'
})
export class AboutComponent {
  categories = ['Business', 'Philosophy', 'Self-Help', 'Science', 'History', 'Psychology', 'Fiction'];
  principles = [
    { title: 'No sponsored content', desc: 'We are not paid by publishers or authors. Every verdict is editorial, not commercial.' },
    { title: 'Honesty over diplomacy', desc: 'If a widely-praised book doesn\'t deliver on its promise, we say so — with evidence.' },
    { title: 'Context matters', desc: 'The same book can be a YES for a beginner and a skip for an expert. We state who the verdict applies to.' },
    { title: 'Time is the unit of measurement', desc: 'Every review converts pages into hours and hours into expected return. Because your time is finite.' },
    { title: 'No artificial FOMO', desc: 'We will not tell you that you "must" read a book. You decide. We just give you the honest data.' },
  ];
}
