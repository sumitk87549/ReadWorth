import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './contact.html'
})
export class ContactComponent {
  contacts = [
    {
      icon: 'email',
      label: 'Email',
      desc: 'Book suggestions, collaboration, or just a good reading recommendation.',
      display: 'Sumitk87549@gmail.com',
      href: 'mailto:Sumitk87549@gmail.com'
    },
    {
      icon: 'phone',
      label: 'WhatsApp / Phone',
      desc: 'Quick questions or urgent enquiries — WhatsApp preferred.',
      display: '+91 79766 11437',
      href: 'https://wa.me/917976611437'
    },
    {
      icon: 'instagram',
      label: 'Instagram',
      desc: 'Behind-the-scenes reading, book pickups, and quick takes.',
      display: '@randomstringx',
      href: 'https://www.instagram.com/randomstringx/'
    },
    {
      icon: 'github',
      label: 'GitHub',
      desc: 'Open source work and the codebase behind ReadWorth.',
      display: 'github.com/sumitk87549',
      href: 'https://github.com/sumitk87549'
    },
    {
      icon: 'linkedin',
      label: 'LinkedIn',
      desc: 'Professional background, projects, and career updates.',
      display: 'linkedin.com/in/sumitdev98',
      href: 'https://www.linkedin.com/in/sumitdev98/'
    }
  ];
}
