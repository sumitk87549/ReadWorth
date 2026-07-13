import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private themeKey = 'readworth-theme';
  isDark = false;

  constructor() {
    this.initTheme();
  }

  private initTheme() {
    const saved = localStorage.getItem(this.themeKey);
    if (saved) {
      this.isDark = saved === 'dark';
    } else {
      this.isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    }
    this.applyTheme();
  }

  toggleTheme() {
    this.isDark = !this.isDark;
    localStorage.setItem(this.themeKey, this.isDark ? 'dark' : 'light');
    this.applyTheme();
  }

  private applyTheme() {
    if (this.isDark) {
      document.documentElement.setAttribute('data-theme', 'dark');
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.setAttribute('data-theme', 'light');
      document.documentElement.classList.remove('dark');
    }
  }
}
