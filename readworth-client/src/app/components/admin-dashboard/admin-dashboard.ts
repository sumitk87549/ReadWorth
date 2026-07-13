import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api.service';
import { Book, Feedback } from '../../models';
import { AdminBookFormComponent } from '../admin-book-form/admin-book-form';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule, AdminBookFormComponent, RouterLink],
  templateUrl: './admin-dashboard.html'
})
export class AdminDashboardComponent implements OnInit {
  private apiService = inject(ApiService);

  books: Book[] = [];
  feedbacks: Feedback[] = [];
  loading = false;
  feedbackLoading = false;

  showForm    = false;
  editingBook: Book | null = null;
  activeTab: 'books' | 'feedback' = 'books';

  ngOnInit() {
    this.loadBooks();
    this.loadFeedback();
  }

  loadBooks() {
    this.loading = true;
    this.apiService.getBooks(undefined, undefined, 0, 100).subscribe({
      next: (data) => { this.books = data.content ?? data; this.loading = false; },
      error: ()    => this.loading = false
    });
  }

  loadFeedback() {
    this.feedbackLoading = true;
    this.apiService.getFeedback().subscribe({
      next: (data) => { this.feedbacks = data; this.feedbackLoading = false; },
      error: ()    => this.feedbackLoading = false
    });
  }

  addNewBook()       { this.editingBook = null;          this.showForm = true; }
  editBook(b: Book)  { this.editingBook = { ...b };      this.showForm = true; }
  onCancelForm()     { this.showForm = false; this.editingBook = null; }

  deleteBook(id: number) {
    if (confirm('Delete this book? This cannot be undone.')) {
      this.apiService.deleteBook(id).subscribe({ next: () => this.loadBooks() });
    }
  }

  onSaveBook(book: Book) {
    const req$ = (this.editingBook?.id)
      ? this.apiService.updateBook(this.editingBook.id, book)
      : this.apiService.createBook(book);

    req$.subscribe({ next: () => { this.showForm = false; this.loadBooks(); } });
  }

  getVerdictStyle(verdict?: string): string {
    if (verdict === 'YES')         return 'color:#16a34a; background:color-mix(in srgb, #16a34a 12%, transparent);';
    if (verdict === 'NO')          return 'color:#dc2626; background:color-mix(in srgb, #dc2626 12%, transparent);';
    return 'color:#d97706; background:color-mix(in srgb, #d97706 12%, transparent);';
  }
}
