import { Component, inject } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService } from './services/auth.service';
import { ThemeService } from './services/theme.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, CommonModule],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  authService = inject(AuthService);
  themeService = inject(ThemeService);
  title    = 'ReadWorth';
  menuOpen = false;

  toggleTheme() { this.themeService.toggleTheme(); }
  logout()      { this.authService.logout(); this.menuOpen = false; }
}
