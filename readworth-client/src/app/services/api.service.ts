import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Book, Category, Feedback } from '../models';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = 'http://localhost:8080/api/v1';

  // Simple in-memory cache
  private booksCache: Map<string, { data: any; expiry: number }> = new Map();
  private readonly CACHE_TTL = 60_000; // 60 seconds

  constructor(private http: HttpClient) {}

  getBooks(query?: string, categoryId?: number, page: number = 0, size: number = 20): Observable<any> {
    const cacheKey = `books-${query ?? ''}-${categoryId ?? ''}-${page}-${size}`;
    const cached = this.booksCache.get(cacheKey);
    if (cached && Date.now() < cached.expiry) {
      return of(cached.data);
    }
    let params = new HttpParams()
      .set('page', page.toString())
      .set('size', size.toString());
    if (query) params = params.set('query', query);
    if (categoryId) params = params.set('categoryId', categoryId.toString());

    return this.http.get(`${this.baseUrl}/books`, { params }).pipe(
      tap(data => this.booksCache.set(cacheKey, { data, expiry: Date.now() + this.CACHE_TTL }))
    );
  }

  getBook(id: number): Observable<Book> {
    return this.http.get<Book>(`${this.baseUrl}/books/${id}`);
  }

  getBookBySlug(slug: string): Observable<Book> {
    const cacheKey = `slug-${slug}`;
    const cached = this.booksCache.get(cacheKey);
    if (cached && Date.now() < cached.expiry) {
      return of(cached.data);
    }
    return this.http.get<Book>(`${this.baseUrl}/books/slug/${slug}`).pipe(
      tap(data => this.booksCache.set(cacheKey, { data, expiry: Date.now() + this.CACHE_TTL }))
    );
  }

  createBook(book: Book): Observable<Book> {
    this.booksCache.clear();
    return this.http.post<Book>(`${this.baseUrl}/books`, book);
  }

  updateBook(id: number, book: Book): Observable<Book> {
    this.booksCache.clear();
    return this.http.put<Book>(`${this.baseUrl}/books/${id}`, book);
  }

  deleteBook(id: number): Observable<void> {
    this.booksCache.clear();
    return this.http.delete<void>(`${this.baseUrl}/books/${id}`);
  }

  getCategories(): Observable<Category[]> {
    return this.http.get<Category[]>(`${this.baseUrl}/categories`);
  }

  submitFeedback(feedback: Feedback): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/feedback`, feedback);
  }

  getFeedback(): Observable<Feedback[]> {
    return this.http.get<Feedback[]>(`${this.baseUrl}/feedback`);
  }
}
