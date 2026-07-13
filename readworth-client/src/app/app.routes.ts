import { Routes } from '@angular/router';
import { LandingComponent } from './components/landing/landing';
import { HomeComponent } from './components/home/home';
import { BookDetailComponent } from './components/book-detail/book-detail';
import { AboutComponent } from './components/about/about';
import { ContactComponent } from './components/contact/contact';
import { FeedbackComponent } from './components/feedback/feedback';
import { AdminLoginComponent } from './components/admin-login/admin-login';
import { AdminDashboardComponent } from './components/admin-dashboard/admin-dashboard';
import { authGuard } from './auth.guard';

export const routes: Routes = [
  { path: '', component: LandingComponent },           // Landing page on logo click
  { path: 'browse', component: HomeComponent },         // Book grid
  { path: 'book/:slug', component: BookDetailComponent }, // SEO slug route
  { path: 'about', component: AboutComponent },
  { path: 'contact', component: ContactComponent },
  { path: 'feedback', component: FeedbackComponent },
  { path: 'login', component: AdminLoginComponent },
  { path: 'admin', component: AdminDashboardComponent, canActivate: [authGuard] },
  { path: '**', redirectTo: '' }
];
