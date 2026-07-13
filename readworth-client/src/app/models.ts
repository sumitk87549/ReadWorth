export interface Category {
  id: number;
  name: string;
}

export interface ExternalLink {
  id?: number;
  label: string;
  url: string;
}

export interface Book {
  id?: number;
  slug?: string;
  title: string;
  authorName: string;
  coverImage?: string;
  aboutDescription?: string;
  authorTrueStory?: string;
  categoryIds?: number[];
  categories?: Category[];
  difficultyLevel?: 'EASY' | 'MODERATE' | 'CHALLENGING';
  lengthLabel?: string;
  languageTone?: string;
  whatToExpect?: string;
  howNotToJudge?: string;
  expectedOutcome?: string;
  expectedTimeInvestment?: number;
  ourRating?: number;
  verdict?: 'YES' | 'NO' | 'CONDITIONAL';
  confidencePercentage?: number;
  verdictReasons?: string[];
  estimatedRoi?: string;
  externalLinks?: ExternalLink[];
  amazonLink?: string;
  goodreadsLink?: string;
}

export interface Feedback {
  id?: number;
  name?: string;
  email?: string;
  message: string;
  submittedAt?: string;
}
