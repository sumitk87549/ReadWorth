import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-feedback',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  templateUrl: './feedback.html'
})
export class FeedbackComponent {
  private fb = inject(FormBuilder);
  private apiService = inject(ApiService);

  feedbackForm = this.fb.group({
    name:    [''],
    email:   ['', [Validators.email]],
    message: ['', [Validators.required, Validators.minLength(10)]]
  });

  submitting = false;
  success    = false;
  error      = '';

  onSubmit() {
    if (this.feedbackForm.valid) {
      this.submitting = true;
      this.error = '';
      this.apiService.submitFeedback(this.feedbackForm.value as any).subscribe({
        next:  () => { this.success = true; this.submitting = false; this.feedbackForm.reset(); },
        error: () => { this.error = 'Something went wrong. Please try again later.'; this.submitting = false; }
      });
    } else {
      this.feedbackForm.markAllAsTouched();
    }
  }

  resetForm() { this.success = false; }

  hasError(field: string): boolean {
    const c = this.feedbackForm.get(field);
    return !!(c?.invalid && c?.touched);
  }
}
