import { Component, inject, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Subject, Subscription } from 'rxjs';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { ApiService } from '../../services/api.service';
import { Book, Category } from '../../models';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './home.html'
})
export class HomeComponent implements OnInit, OnDestroy {
  private apiService = inject(ApiService);
  private cdr       = inject(ChangeDetectorRef);   // ← fixes "books invisible" bug
  private searchSubject = new Subject<string>();
  private subs: Subscription[] = [];

  books: Book[] = [];
  categories: Category[] = [];
  searchQuery = '';
  selectedCategory: number | undefined;
  loading = true;
  error = '';

  ngOnInit() {
    this.loadCategories();
    this.loadBooks();

    // Debounce search: wait 350ms after last keystroke
    this.subs.push(
      this.searchSubject.pipe(debounceTime(350), distinctUntilChanged())
        .subscribe(() => this.loadBooks())
    );
  }

  ngOnDestroy() { this.subs.forEach(s => s.unsubscribe()); }

  loadCategories() {
    this.apiService.getCategories().subscribe({
      next: (data) => { this.categories = data; this.cdr.detectChanges(); },
      error: (err) => console.error('Failed to load categories', err)
    });
  }

  loadBooks() {
    this.loading = true;
    this.error = '';
    this.cdr.detectChanges();

    this.apiService.getBooks(this.searchQuery || undefined, this.selectedCategory).subscribe({
      next: (data) => {
        this.books = data.content ?? data;
        this.loading = false;
        this.cdr.detectChanges();   // ← force render immediately
      },
      error: () => {
        this.error = 'Failed to load books. Make sure the backend is running on port 8080.';
        this.loading = false;
        this.cdr.detectChanges();
      }
    });
  }

  onSearchInput() { this.searchSubject.next(this.searchQuery); }
  onSearch()      { this.loadBooks(); }

  onFilter(categoryId?: number) {
    this.selectedCategory = categoryId;
    this.loadBooks();
  }

  getBookLink(book: Book): string[] {
    return ['/book', book.slug || book.id?.toString() || ''];
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

  getStars(rating?: number): number[]      { return Array(Math.min(rating ?? 0, 5)).fill(0); }
  getEmptyStars(rating?: number): number[] { return Array(5 - Math.min(rating ?? 0, 5)).fill(0); }
}
