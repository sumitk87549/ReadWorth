import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Book } from '../../models';

@Component({
  selector: 'app-landing',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './landing.html'
})
export class LandingComponent implements OnInit {
  private apiService = inject(ApiService);
  private cdr       = inject(ChangeDetectorRef);

  featuredBooks: Book[] = [];
  loading = true;

  readonly steps = [
    { num: '01', title: 'We Read the Book',    desc: 'Full cover-to-cover read. No SparkNotes, no outsourcing. If we haven\'t read it end-to-end, we don\'t review it.' },
    { num: '02', title: 'We Set the Stakes',   desc: 'Who is this really for? What will it cost you in time? What\'s the realistic, lasting takeaway — not the marketing pitch?' },
    { num: '03', title: 'We Give the Verdict', desc: 'YES / NO / CONDITIONAL — with a confidence percentage and bulletproof reasons. No hedging, no diplomatic ambiguity.' },
    { num: '04', title: 'You Decide Fast',      desc: 'Open the page, get the verdict in under 60 seconds. Start reading knowing exactly what you\'re in for — or move on guilt-free.' },
  ];

  ngOnInit() {
    this.apiService.getBooks(undefined, undefined, 0, 100).subscribe({
      next: (data) => {
        const books = data.content ?? data;
        // Show up to 6 YES books as featured; fall back to all books if fewer YES
        const yes = books.filter((b: Book) => b.verdict === 'YES');
        this.featuredBooks = yes.length >= 4 ? yes.slice(0, 6) : books.slice(0, 6);
        this.loading = false;
        this.cdr.detectChanges();
      },
      error: () => { this.loading = false; this.cdr.detectChanges(); }
    });
  }

  getVerdictLabel(verdict?: string): string {
    if (verdict === 'YES') return 'Worth It';
    if (verdict === 'NO')  return 'Skip It';
    return 'Maybe';
  }

  getVerdictClass(verdict?: string): string {
    if (verdict === 'YES') return 'verdict-yes';
    if (verdict === 'NO')  return 'verdict-no';
    return 'verdict-cond';
  }

  getBookLink(book: Book): string[] {
    return ['/book', book.slug || book.id?.toString() || ''];
  }

  getStars(rating?: number): number[]      { return Array(Math.min(rating ?? 0, 5)).fill(0); }
  getEmptyStars(rating?: number): number[] { return Array(5 - Math.min(rating ?? 0, 5)).fill(0); }
}
