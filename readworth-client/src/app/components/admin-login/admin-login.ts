import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-admin-login',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule, RouterLink],
  templateUrl: './admin-login.html'
})
export class AdminLoginComponent {
  private fb          = inject(FormBuilder);
  private authService = inject(AuthService);
  private router      = inject(Router);

  loginForm = this.fb.group({
    username: ['', Validators.required],
    password: ['', Validators.required]
  });

  loading = false;
  error   = '';
  showPassword = false;

  onSubmit() {
    if (this.loginForm.valid) {
      this.loading = true;
      this.error   = '';
      this.authService.login(this.loginForm.value).subscribe({
        next: ()  => this.router.navigate(['/admin']),
        error: () => { this.error = 'Invalid credentials. Try again.'; this.loading = false; }
      });
    }
  }
}
