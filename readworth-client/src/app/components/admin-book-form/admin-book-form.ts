import { Component, Input, Output, EventEmitter, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule, FormArray } from '@angular/forms';
import { Book, Category } from '../../models';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-admin-book-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './admin-book-form.html'
})
export class AdminBookFormComponent implements OnInit {
  @Input() book: Book | null = null;
  @Output() save = new EventEmitter<Book>();
  @Output() cancel = new EventEmitter<void>();

  private fb = inject(FormBuilder);
  private apiService = inject(ApiService);

  bookForm!: FormGroup;
  categories: Category[] = [];

  ngOnInit() {
    this.apiService.getCategories().subscribe(cats => {
      this.categories = cats;
    });

    this.initForm();
    if (this.book) {
      this.patchForm(this.book);
    }
  }

  initForm() {
    this.bookForm = this.fb.group({
      title: ['', Validators.required],
      authorName: ['', Validators.required],
      coverImage: [''],
      aboutDescription: [''],
      authorTrueStory: [''],
      categoryIds: [[]],
      difficultyLevel: ['MODERATE'],
      lengthLabel: [''],
      languageTone: [''],
      whatToExpect: [''],
      howNotToJudge: [''],
      expectedOutcome: [''],
      expectedTimeInvestment: [0],
      ourRating: [3],
      verdict: ['CONDITIONAL'],
      confidencePercentage: [50],
      verdictReasons: this.fb.array([]),
      estimatedRoi: [''],
      externalLinks: this.fb.array([])
    });
  }

  patchForm(book: Book) {
    this.bookForm.patchValue({
      title: book.title,
      authorName: book.authorName,
      coverImage: book.coverImage,
      aboutDescription: book.aboutDescription,
      authorTrueStory: book.authorTrueStory,
      categoryIds: book.categoryIds || book.categories?.map(c => c.id) || [],
      difficultyLevel: book.difficultyLevel,
      lengthLabel: book.lengthLabel,
      languageTone: book.languageTone,
      whatToExpect: book.whatToExpect,
      howNotToJudge: book.howNotToJudge,
      expectedOutcome: book.expectedOutcome,
      expectedTimeInvestment: book.expectedTimeInvestment,
      ourRating: book.ourRating,
      verdict: book.verdict,
      confidencePercentage: book.confidencePercentage,
      estimatedRoi: book.estimatedRoi,
    });

    if (book.verdictReasons) {
      book.verdictReasons.forEach(r => this.addVerdictReason(r));
    }
    if (book.externalLinks) {
      book.externalLinks.forEach(l => this.addExternalLink(l.label, l.url));
    }
  }

  get verdictReasons() {
    return this.bookForm.get('verdictReasons') as FormArray;
  }

  addVerdictReason(reason: string = '') {
    this.verdictReasons.push(this.fb.control(reason, Validators.required));
  }

  removeVerdictReason(index: number) {
    this.verdictReasons.removeAt(index);
  }

  get externalLinks() {
    return this.bookForm.get('externalLinks') as FormArray;
  }

  addExternalLink(label: string = '', url: string = '') {
    this.externalLinks.push(this.fb.group({
      label: [label, Validators.required],
      url: [url, Validators.required]
    }));
  }

  removeExternalLink(index: number) {
    this.externalLinks.removeAt(index);
  }

  onCategoryChange(event: any, categoryId: number) {
    const ids = this.bookForm.get('categoryIds')?.value as number[];
    if (event.target.checked) {
      ids.push(categoryId);
    } else {
      const index = ids.indexOf(categoryId);
      if (index >= 0) ids.splice(index, 1);
    }
    this.bookForm.patchValue({ categoryIds: ids });
  }

  isCategorySelected(categoryId: number): boolean {
    const ids = this.bookForm.get('categoryIds')?.value as number[];
    return ids ? ids.includes(categoryId) : false;
  }

  onSubmit() {
    if (this.bookForm.valid) {
      const formValue = this.bookForm.value;
      this.save.emit(formValue as Book);
    } else {
      this.bookForm.markAllAsTouched();
    }
  }
}
