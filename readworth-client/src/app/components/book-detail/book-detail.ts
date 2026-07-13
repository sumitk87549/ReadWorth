import { Component, inject, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Book } from '../../models';

@Component({
  selector: 'app-book-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './book-detail.html',
  styleUrl: './book-detail.css'
})
export class BookDetailComponent implements OnInit {
  private route    = inject(ActivatedRoute);
  private api      = inject(ApiService);
  private cdr      = inject(ChangeDetectorRef);   // ← fixes the "ghost" render bug

  book: Book | null = null;
  loading = true;
  error   = '';
  activeTab: 'about' | 'story' | 'expect' | 'outcome' | 'howto' = 'about';

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      const slug = params.get('slug');
      if (slug) this.loadBook(slug);
    });
  }

  loadBook(slug: string) {
    this.loading = true;
    this.error   = '';
    this.book    = null;

    this.api.getBookBySlug(slug).subscribe({
      next: (data) => {
        this.book    = data;
        this.loading = false;
        this.cdr.detectChanges();   // ← forces Angular to re-render after async data arrives
      },
      error: () => {
        this.error   = 'Book not found. It may have been removed or the URL is incorrect.';
        this.loading = false;
        this.cdr.detectChanges();
      }
    });
  }

  setTab(tab: typeof this.activeTab) { this.activeTab = tab; }

  getStars(r?: number): number[]      { return Array(Math.min(r ?? 0, 5)).fill(0); }
  getEmptyStars(r?: number): number[] { return Array(5 - Math.min(r ?? 0, 5)).fill(0); }

  get verdictColor(): string {
    if (this.book?.verdict === 'YES') return '#16a34a';
    if (this.book?.verdict === 'NO')  return '#dc2626';
    return '#d97706';
  }

  get verdictLabel(): string {
    if (this.book?.verdict === 'YES') return '✓ Worth Your Time';
    if (this.book?.verdict === 'NO')  return '✕ Skip This One';
    return '~ It Depends';
  }

  get difficultyColor(): string {
    if (this.book?.difficultyLevel === 'EASY')       return '#16a34a';
    if (this.book?.difficultyLevel === 'CHALLENGING') return '#dc2626';
    return '#d97706';
  }

  get primaryCategory(): string {
    return this.book?.categories?.[0]?.name ?? 'General';
  }
}
