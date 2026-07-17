# ReadWorth - Complete Project Documentation

## 📖 Project Overview

**ReadWorth** is a decision-first book review platform that helps users determine whether a book is worth their time. Unlike traditional review sites, ReadWorth provides definitive verdicts (YES/NO/CONDITIONAL) with confidence scores and clear reasoning, enabling readers to make informed decisions in 60 seconds rather than spending 8-20 hours on the wrong book.

### Core Value Proposition
- **Not a summary. Not a fan review. A definitive verdict.**
- Every review includes a confidence score and exact reasoning
- Three clear verdicts: YES (Worth Your Time), CONDITIONAL (Depends on You), NO (Skip It)
- Saves readers from wasting time on books that don't deliver

---

## 🏗️ Architecture Overview

ReadWorth follows a **client-server architecture** with:

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Frontend** | Angular 21+ | Single-page application (SPA) for user interface |
| **Backend** | Spring Boot 4.1.0 (Java 17) | RESTful API server |
| **Database** | H2 (dev) / PostgreSQL (prod) | Relational data storage |
| **Security** | JWT + Spring Security | Stateless authentication |
| **Migration** | Flyway (configured, disabled in dev) | Database version control |

### Project Structure
```
/workspace
├── ReadWorth/                 # Backend (Spring Boot)
│   ├── src/main/java/com/readlyte/ReadWorth/
│   │   ├── controller/        # REST API endpoints
│   │   ├── service/           # Business logic
│   │   ├── repository/        # Data access layer (JPA)
│   │   ├── entity/            # JPA entities (database models)
│   │   ├── dto/               # Data Transfer Objects
│   │   ├── security/          # JWT & Spring Security config
│   │   └── exception/         # Global error handling
│   ├── src/main/resources/
│   │   ├── application.yml    # Configuration
│   │   ├── data.sql           # Seed data
│   │   └── db/migration/      # Flyway migrations
│   └── pom.xml                # Maven dependencies
│
└── readworth-client/          # Frontend (Angular)
    ├── src/app/
    │   ├── components/        # UI components
    │   ├── services/          # API & auth services
    │   ├── models.ts          # TypeScript interfaces
    │   ├── app.routes.ts      # Route definitions
    │   ├── auth.guard.ts      # Route protection
    │   └── auth.interceptor.ts# JWT token injection
    ├── package.json           # npm dependencies
    └── angular.json           # Angular CLI config
```

---

## 🔧 Backend (Spring Boot) - Technical Deep Dive

### Technology Stack
- **Framework:** Spring Boot 4.1.0
- **Language:** Java 17
- **ORM:** Spring Data JPA with Hibernate
- **Security:** Spring Security + JWT (io.jsonwebtoken 0.12.5)
- **Validation:** Jakarta Validation (Hibernate Validator)
- **Database:** H2 (in-memory for development), PostgreSQL (production-ready)
- **Build Tool:** Maven

### Key Dependencies (pom.xml)
```xml
- spring-boot-starter-data-jpa      # JPA/Hibernate ORM
- spring-boot-starter-security      # Security framework
- spring-boot-starter-validation    # Request validation
- spring-boot-starter-web           # REST API
- flyway-core                       # DB migrations
- jjwt-api/impl/jackson             # JWT tokens
- postgresql                        # Production database
- h2                                # Development database
- lombok                            # Boilerplate reduction
```

### Application Configuration (application.yml)
```yaml
spring:
  datasource: jdbc:h2:mem:readworth  # In-memory DB for dev
  jpa.hibernate.ddl-auto: create-drop
  sql.init.mode: always              # Load data.sql on startup
  
jwt:
  secret: <64-char hex string>       # HMAC-SHA key for JWT signing
  expiration-ms: 14400000            # 4 hours token validity
  
server:
  port: 8080
```

---

### Database Schema

#### Tables Overview

**1. admin_users** - Admin authentication
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT |
| username | VARCHAR(255) | UNIQUE, NOT NULL |
| password | VARCHAR(255) | NOT NULL (BCrypt hashed) |
| role | VARCHAR(50) | NOT NULL (e.g., ROLE_ADMIN) |

**2. categories** - Book categories
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT |
| name | VARCHAR(255) | UNIQUE, NOT NULL |

**3. books** - Main book reviews
| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key |
| title | VARCHAR(255) | Book title |
| slug | VARCHAR(255) | SEO-friendly URL identifier |
| author_name | VARCHAR(255) | Author name |
| cover_image | VARCHAR(1024) | Cover image URL |
| about_description | TEXT | Brief description |
| author_true_story | TEXT | Author background |
| difficulty_level | ENUM | EASY/MODERATE/CHALLENGING |
| length_label | VARCHAR(255) | e.g., "320 pages" |
| language_tone | VARCHAR(255) | Writing style description |
| what_to_expect | TEXT | Content expectations |
| how_not_to_judge | TEXT | Common misconceptions |
| expected_outcome | TEXT | What readers gain |
| expected_time_investment | DOUBLE | Hours to read |
| our_rating | INTEGER | 1-5 rating |
| verdict | ENUM | YES/NO/CONDITIONAL |
| confidence_percentage | INTEGER | 0-100 confidence score |
| estimated_roi | VARCHAR(255) | Return on investment description |
| created_at, updated_at | TIMESTAMP | Audit timestamps |

**4. book_categories** - Many-to-many junction table
| Column | Type | Constraints |
|--------|------|-------------|
| book_id | BIGINT | FOREIGN KEY → books(id), ON DELETE CASCADE |
| category_id | BIGINT | FOREIGN KEY → categories(id), ON DELETE CASCADE |
| PRIMARY KEY | (book_id, category_id) | Composite key |

**5. book_verdict_reasons** - Reasons for verdict (one-to-many)
| Column | Type | Description |
|--------|------|-------------|
| book_id | BIGINT | FOREIGN KEY → books(id) |
| reason | TEXT | Individual reason text |

**6. external_links** - External purchase/info links
| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key |
| book_id | BIGINT | FOREIGN KEY → books(id) |
| label | VARCHAR(255) | Link label (e.g., "Amazon") |
| url | VARCHAR(1024) | Full URL |

**7. feedback** - User feedback submissions
| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key |
| name, email | VARCHAR(255) | Optional contact info |
| message | TEXT | Feedback content |
| submitted_at | TIMESTAMP | Submission timestamp |

---

### Entity Classes (JPA)

#### Book.java (Core Entity)
```java
@Entity
@Table(name = "books")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(unique = true)
    private String slug;  // SEO-friendly URL

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "book_categories", ...)
    private Set<Category> categories;

    @Enumerated(EnumType.STRING)
    private DifficultyLevel difficultyLevel;  // EASY, MODERATE, CHALLENGING

    @Enumerated(EnumType.STRING)
    private Verdict verdict;  // YES, NO, CONDITIONAL

    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "book_verdict_reasons", ...)
    private List<String> verdictReasons;

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ExternalLink> externalLinks;

    // ... other fields with @CreationTimestamp, @UpdateTimestamp
}
```

#### Enums Used
```java
// DifficultyLevel.java
public enum DifficultyLevel { EASY, MODERATE, CHALLENGING }

// Verdict.java
public enum Verdict { YES, NO, CONDITIONAL }
```

---

### Repository Layer (Data Access)

#### BookRepository.java
```java
public interface BookRepository extends JpaRepository<Book, Long> {
    Optional<Book> findBySlug(String slug);  // SEO lookup

    @Query("SELECT b FROM Book b LEFT JOIN b.categories c WHERE " +
           "(:query IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :query, '%')) " +
           "OR LOWER(b.authorName) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
           "(:categoryId IS NULL OR c.id = :categoryId)")
    Page<Book> searchAndFilter(@Param("query") String query, 
                               @Param("categoryId") Long categoryId, 
                               Pageable pageable);
}
```

**Key Features:**
- Pagination support via `Pageable`
- Case-insensitive search on title and author
- Category filtering
- Slug-based lookup for SEO-friendly URLs

#### Other Repositories
- `CategoryRepository` - Simple CRUD for categories
- `FeedbackRepository` - CRUD for feedback submissions
- `AdminUserRepository` - Admin user lookups for authentication

---

### Service Layer (Business Logic)

#### BookService.java

**Key Methods:**

1. **getBooks(query, categoryId, pageable)** - Search & filter with pagination
   - Calls repository's `searchAndFilter()`
   - Maps entities to DTOs

2. **getBookById(id)** - Get single book by ID
   - Throws `RuntimeException` if not found

3. **getBookBySlug(slug)** - SEO-friendly lookup
   - Used for `/book/:slug` routes

4. **createBook(bookDTO)** - Create new book review
   - Auto-generates slug if not provided
   - Transactional operation

5. **updateBook(id, bookDTO)** - Update existing review
   - Merges DTO data with existing entity
   - Clears and rebuilds collections (categories, links, reasons)

6. **deleteBook(id)** - Soft delete via JPA
   - Cascade deletes related entities

**Slug Generation:**
```java
public static String generateSlug(String title) {
    // "Atomic Habits" → "atomic-habits"
    // Removes diacritics, special chars, converts to lowercase kebab-case
}
```

**DTO Mapping:**
- `mapToDTO(Book)` - Entity → DTO (for API responses)
- `mapToEntity(BookDTO, Book)` - DTO → Entity (for saves/updates)
- Handles nested objects (categories, externalLinks, verdictReasons)

---

### Controller Layer (REST API)

#### Base URL: `/api/v1`

#### BookController.java (`/api/v1/books`)

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| GET | `/books` | ❌ | List books with pagination, search, filter |
| GET | `/books/{id}` | ❌ | Get book by ID |
| GET | `/books/slug/{slug}` | ❌ | Get book by SEO slug |
| POST | `/books` | ✅ | Create new book review |
| PUT | `/books/{id}` | ✅ | Update existing review |
| DELETE | `/books/{id}` | ✅ | Delete review |

**Query Parameters for GET /books:**
- `query` (optional) - Search term for title/author
- `categoryId` (optional) - Filter by category ID
- `page` (default: 0) - Page number
- `size` (default: 20) - Items per page

#### AuthController.java (`/api/v1/auth`)

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| POST | `/auth/login` | ❌ | Authenticate admin, return JWT |

**Login Request:**
```json
{
  "username": "admin",
  "password": "admin"
}
```

**Login Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

#### CategoryController.java (`/api/v1/categories`)

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| GET | `/categories` | ❌ | List all categories |

#### FeedbackController.java (`/api/v1/feedback`)

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| POST | `/feedback` | ❌ | Submit user feedback |
| GET | `/feedback` | ✅ | Get all feedback (admin only) |

---

### Security Implementation

#### JWT Authentication Flow

1. **Login:** Admin submits credentials → `/api/v1/auth/login`
2. **Validation:** Spring Security authenticates against `AdminUserRepository`
3. **Token Generation:** `JwtUtil.generateToken(username)` creates signed JWT
4. **Storage:** Frontend stores token in `localStorage`
5. **Subsequent Requests:** Frontend sends `Authorization: Bearer <token>` header
6. **Validation:** `JwtAuthenticationFilter` intercepts requests, validates token
7. **Context Setup:** Sets `SecurityContext` with authenticated user details

#### JwtUtil.java
```java
@Component
public class JwtUtil {
    @Value("${jwt.secret}")
    private String secret;  // 64-char hex string for HMAC-SHA256

    @Value("${jwt.expiration-ms}")
    private Long jwtExpirationMs;  // 4 hours

    public String generateToken(String username) {
        return Jwts.builder()
            .subject(username)
            .issuedAt(new Date())
            .expiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
            .signWith(getSigningKey())  // HMAC-SHA256
            .compact();
    }

    public Boolean validateToken(String token, String username) {
        // Checks signature, expiration, and username match
    }
}
```

#### SecurityConfig.java
```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .cors(cors -> cors.configurationSource(corsConfigurationSource()))
        .csrf(csrf -> csrf.disable())  // Statelessness
        .authorizeHttpRequests(auth -> auth
            .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
            .requestMatchers("/api/v1/auth/login").permitAll()
            .requestMatchers(HttpMethod.GET, "/api/v1/books/**").permitAll()
            .requestMatchers(HttpMethod.GET, "/api/v1/categories").permitAll()
            .requestMatchers(HttpMethod.POST, "/api/v1/feedback").permitAll()
            .anyRequest().authenticated()  // All other endpoints require JWT
        )
        .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
    return http.build();
}
```

**CORS Configuration:**
- Allowed Origins: `http://localhost:4200` (Angular dev server)
- Allowed Methods: GET, POST, PUT, DELETE, OPTIONS
- Allowed Headers: Authorization, Content-Type
- Exposed Headers: Authorization

#### CustomUserDetailsService.java
```java
@Service
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private AdminUserRepository repo;

    @Override
    public UserDetails loadUserByUsername(String username) {
        AdminUser user = repo.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException(...));
        return org.springframework.security.core.userdetails.User
            .withUsername(user.getUsername())
            .password(user.getPassword())  // BCrypt hashed
            .roles(user.getRole())
            .build();
    }
}
```

#### JwtAuthenticationFilter.java
```java
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                    HttpServletResponse response, 
                                    FilterChain filterChain) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            String username = jwtUtil.extractUsername(token);
            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                if (jwtUtil.validateToken(token, username)) {
                    // Set authentication in SecurityContext
                    UsernamePasswordAuthenticationToken authToken = 
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            }
        }
        filterChain.doFilter(request, response);
    }
}
```

---

### DTOs (Data Transfer Objects)

#### BookDTO.java
```java
public class BookDTO {
    private Long id;
    private String slug;
    private String title;
    private String authorName;
    private String coverImage;
    private String aboutDescription;
    private String authorTrueStory;
    private List<Long> categoryIds;  // For input
    private List<CategoryDTO> categories;  // For output
    private DifficultyLevel difficultyLevel;
    private String lengthLabel;
    private String languageTone;
    private String whatToExpect;
    private String howNotToJudge;
    private String expectedOutcome;
    private Double expectedTimeInvestment;
    private Integer ourRating;
    private Verdict verdict;
    private Integer confidencePercentage;
    private List<String> verdictReasons;
    private String estimatedRoi;
    private List<ExternalLinkDTO> externalLinks;
}
```

#### Other DTOs
- `CategoryDTO` - id, name
- `ExternalLinkDTO` - id, label, url
- `FeedbackDTO` - name, email, message
- `LoginRequest` - username, password
- `JwtResponse` - token
- `ErrorResponse` - timestamp, status, error, message, path

---

### Exception Handling

#### GlobalExceptionHandler.java
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(...) {
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationErrors(...) {
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(...) {
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
```

---

### Database Initialization

#### Seed Data (data.sql / V2__seed_data.sql)

**Default Admin User:**
```sql
INSERT INTO admin_users (username, password, role) 
VALUES ('admin', '$2a$10$wTf2WcW.4r.V0tZg7NnU2OTe2vK5E1kS9hE2/w6v.S.V0tZg7NnU2', 'ROLE_ADMIN');
-- Password: 'admin' (BCrypt hashed)
```

**Categories:**
- Business, Philosophy, Fiction, Self-Help, History

**Sample Books (8 pre-seeded):**
1. Atomic Habits - James Clear (Verdict: YES, Rating: 5/5)
2. Thinking, Fast and Slow - Daniel Kahneman (Verdict: CONDITIONAL, Rating: 4/5)
3. The Subtle Art of Not Giving a F*ck - Mark Manson (Verdict: YES, Rating: 4/5)
4. Dune - Frank Herbert (Verdict: YES, Rating: 5/5)
5. Sapiens - Yuval Noah Harari (Verdict: YES, Rating: 5/5)
6. The 4-Hour Workweek - Timothy Ferriss (Verdict: NO, Rating: 3/5)
7. Meditations - Marcus Aurelius (Verdict: YES, Rating: 5/5)
8. Project Hail Mary - Andy Weir (Verdict: CONDITIONAL, Rating: 4/5)

Each book includes:
- Cover image URL
- Detailed descriptions
- Verdict reasons (2 per book)
- External links (Amazon)
- Category associations

---

## 🎨 Frontend (Angular) - Technical Deep Dive

### Technology Stack
- **Framework:** Angular 21.1.0
- **Language:** TypeScript 5.9
- **Styling:** Tailwind CSS 4.1.12 + Custom CSS variables
- **HTTP Client:** Angular HttpClient with RxJS
- **State Management:** Signals (Angular 17+) + Local Storage
- **Testing:** Vitest 4.0.8
- **Build Tool:** Angular CLI (@angular/build)

### Project Configuration

#### package.json Dependencies
```json
{
  "@angular/common": "^21.1.0",
  "@angular/core": "^21.1.0",
  "@angular/router": "^21.1.0",
  "@angular/forms": "^21.1.0",
  "rxjs": "~7.8.0",
  "tailwindcss": "^4.1.12",
  "@tailwindcss/postcss": "^4.1.12"
}
```

#### App Configuration (app.config.ts)
```typescript
export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(withInterceptors([authInterceptor]))
  ]
};
```

---

### Routing Configuration

#### app.routes.ts
```typescript
export const routes: Routes = [
  { path: '', component: LandingComponent },           // Landing page
  { path: 'browse', component: HomeComponent },         // Book grid
  { path: 'book/:slug', component: BookDetailComponent }, // Book detail
  { path: 'about', component: AboutComponent },
  { path: 'contact', component: ContactComponent },
  { path: 'feedback', component: FeedbackComponent },
  { path: 'login', component: AdminLoginComponent },
  { path: 'admin', component: AdminDashboardComponent, canActivate: [authGuard] },
  { path: '**', redirectTo: '' }  // Wildcard → Landing
];
```

**Route Protection:**
- `/admin` route protected by `authGuard`
- Redirects to `/login` if no JWT token present

---

### Core Services

#### ApiService.ts
**Base URL:** `http://localhost:8080/api/v1`

**Caching Strategy:**
- In-memory cache with 60-second TTL
- Cache keys based on request parameters
- Cache cleared on write operations (create/update/delete)

```typescript
@Injectable({ providedIn: 'root' })
export class ApiService {
  private baseUrl = 'http://localhost:8080/api/v1';
  private booksCache: Map<string, { data: any; expiry: number }> = new Map();
  private readonly CACHE_TTL = 60_000; // 60 seconds

  getBooks(query?: string, categoryId?: number, page: number = 0, size: number = 20): Observable<any> {
    const cacheKey = `books-${query ?? ''}-${categoryId ?? ''}-${page}-${size}`;
    const cached = this.booksCache.get(cacheKey);
    if (cached && Date.now() < cached.expiry) {
      return of(cached.data);  // Return cached data
    }
    let params = new HttpParams().set('page', page).set('size', size);
    if (query) params = params.set('query', query);
    if (categoryId) params = params.set('categoryId', categoryId);
    
    return this.http.get(`${this.baseUrl}/books`, { params }).pipe(
      tap(data => this.booksCache.set(cacheKey, { data, expiry: Date.now() + this.CACHE_TTL }))
    );
  }

  getBookBySlug(slug: string): Observable<Book> {
    const cacheKey = `slug-${slug}`;
    // Similar caching logic
    return this.http.get<Book>(`${this.baseUrl}/books/slug/${slug}`);
  }

  createBook(book: Book): Observable<Book> {
    this.booksCache.clear();  // Invalidate cache
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
    return this.http.get<Feedback[]>(`${this.baseUrl}/feedback`);  // Admin only
  }
}
```

#### AuthService.ts
```typescript
@Injectable({ providedIn: 'root' })
export class AuthService {
  private apiUrl = 'http://localhost:8080/api/v1/auth';
  private tokenKey = 'readworth-jwt';
  
  isAuthenticated = signal(this.hasToken());  // Angular Signal

  login(credentials: any) {
    return this.http.post<{token: string}>(`${this.apiUrl}/login`, credentials).pipe(
      tap(res => {
        if (res && res.token) {
          localStorage.setItem(this.tokenKey, res.token);
          this.isAuthenticated.set(true);
        }
      })
    );
  }

  logout() {
    localStorage.removeItem(this.tokenKey);
    this.isAuthenticated.set(false);
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
  }

  hasToken(): boolean {
    return !!this.getToken();
  }
}
```

---

### HTTP Interceptor

#### auth.interceptor.ts
```typescript
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);
  const token = authService.getToken();

  if (token) {
    const cloned = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`
      }
    });
    return next(cloned);
  }
  return next(req);
};
```

**Purpose:** Automatically attaches JWT token to all outgoing HTTP requests (except public endpoints).

---

### Route Guards

#### auth.guard.ts
```typescript
export const authGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  if (authService.hasToken()) {
    return true;
  }
  return router.parseUrl('/login');  // Redirect to login
};
```

---

### TypeScript Models

#### models.ts
```typescript
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
```

---

### Components Structure

#### 1. LandingComponent (`/`)
**Purpose:** Hero page with value proposition, methodology explainer, featured books

**Key Features:**
- Animated gradient background
- Floating book decorations (CSS animations)
- Stats bar (10+ Books Reviewed, 200+ Hours Saved, 90% Avg Confidence)
- "How We Decide" methodology section (4 steps)
- Verdict explainer cards (YES/CONDITIONAL/NO)
- Featured books grid (editor's picks)
- CTA banner

**Template Highlights:**
- Uses CSS custom properties (variables) for theming
- Responsive grid layouts
- Skeleton loading states
- Smooth fade-in animations

---

#### 2. HomeComponent (`/browse`)
**Purpose:** Browse all book reviews with search and filtering

**Key Features:**
- Search bar (title/author search)
- Category filter pills (All, Business, Philosophy, etc.)
- Responsive book grid (auto-fill, minmax 180px)
- Loading skeletons
- Error state handling
- Empty state messaging
- Verdict badges on each card
- Star ratings display

**Component Logic:**
```typescript
export class HomeComponent implements OnInit {
  books: Book[] = [];
  categories: Category[] = [];
  loading = false;
  searchQuery = '';
  selectedCategory: number | undefined;

  ngOnInit() {
    this.loadBooks();
    this.apiService.getCategories().subscribe(cats => this.categories = cats);
  }

  loadBooks() {
    this.loading = true;
    this.apiService.getBooks(this.searchQuery, this.selectedCategory)
      .subscribe({
        next: (data) => { 
          this.books = data.content ?? data; 
          this.loading = false; 
        },
        error: () => this.loading = false
      });
  }

  onSearch() { this.loadBooks(); }
  onFilter(categoryId: number | undefined) {
    this.selectedCategory = categoryId;
    this.loadBooks();
  }

  getVerdictClass(verdict?: string): string {
    if (verdict === 'YES') return 'verdict-yes';
    if (verdict === 'NO') return 'verdict-no';
    return 'verdict-conditional';
  }

  getBookLink(book: Book): string {
    return `/book/${book.slug || book.id}`;
  }
}
```

---

#### 3. BookDetailComponent (`/book/:slug`)
**Purpose:** Detailed book review page with full verdict breakdown

**Key Features:**
- Large cover image with shadow
- External links (Amazon, GoodReads, custom links)
- Badge chips (category, difficulty level)
- Star rating display
- Quick stat chips (Read Time, ROI, Confidence)
- Prominent verdict badge with color coding
- Verdict reasons list
- Tabbed sections:
  - About the Book
  - About the Author
  - What to Expect
  - How NOT to Judge
  - Expected Outcome
- Related books section (same category)

**Color Coding:**
- YES verdict: Green (#16a34a)
- NO verdict: Red (#dc2626)
- CONDITIONAL verdict: Orange (#d97706)
- Difficulty levels: EASY (green), MODERATE (orange), CHALLENGING (red)

---

#### 4. AdminLoginComponent (`/login`)
**Purpose:** Admin authentication

**Template:**
- Username/password form
- Validation feedback
- Error message display
- Redirects to `/admin` on success

**Logic:**
```typescript
login() {
  this.authService.login({ 
    username: this.username, 
    password: this.password 
  }).subscribe({
    next: () => this.router.navigate(['/admin']),
    error: () => this.error = 'Invalid credentials'
  });
}
```

---

#### 5. AdminDashboardComponent (`/admin`)
**Purpose:** Admin panel for managing books and viewing feedback

**Key Features:**
- Tabbed interface: Books | Feedback
- Books tab:
  - Table of all books (title, author, verdict, rating, actions)
  - "Add New Book" button
  - Edit/Delete actions per row
  - Verdict color coding
- Feedback tab:
  - List of user feedback submissions
  - Name, email, message, submission date
- Modal form for creating/editing books

**Form Fields (AdminBookFormComponent):**
- Title, Author Name, Slug (auto-generated)
- Cover Image URL
- About Description, Author True Story
- Categories (multi-select checkboxes)
- Difficulty Level (dropdown)
- Length Label, Language Tone
- What to Expect, How Not to Judge, Expected Outcome
- Expected Time Investment (hours)
- Our Rating (1-5 stars)
- Verdict (YES/NO/CONDITIONAL)
- Confidence Percentage (0-100)
- Estimated ROI
- Verdict Reasons (dynamic list, add/remove)
- External Links (dynamic list, label + URL)

---

#### 6. FeedbackComponent (`/feedback`)
**Purpose:** User feedback submission form

**Fields:**
- Name (optional)
- Email (optional)
- Message (required)

**Validation:**
- Message required, minimum length
- Email format validation (if provided)

---

#### 7. AboutComponent (`/about`)
**Purpose:** Explain ReadWorth's methodology

**Content:**
- Mission statement
- Review process explanation
- Team/philosophy section

---

#### 8. ContactComponent (`/contact`)
**Purpose:** Contact information/form

---

### Styling System

#### CSS Custom Properties (Design Tokens)

Defined in global styles (likely `styles.css` or `app.css`):

```css
:root {
  /* Typography */
  --font-serif: 'Merriweather', Georgia, serif;
  --font-sans: 'Inter', system-ui, sans-serif;

  /* Colors */
  --cream: #FDF8F4;
  --oak: #5D534A;
  --ink: #1A1A1A;
  --muted: #6B6B6B;
  --border: #E5E0D8;
  --surface: #FFFFFF;
  --accent: #C45C2B;  /* Primary brand color (terracotta) */

  /* Spacing */
  --space-xs: 0.25rem;
  --space-sm: 0.5rem;
  --space-md: 1rem;
  --space-lg: 1.5rem;
  --space-xl: 2rem;

  /* Border radius */
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-xl: 1rem;

  /* Shadows */
  --shadow-sm: 0 1px 3px rgba(0,0,0,0.08);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.1);
  --shadow-lg: 0 12px 36px rgba(0,0,0,0.12);
}
```

#### Utility Classes
- `.btn-primary` - Primary action button (accent background)
- `.btn-secondary` - Secondary button (outline style)
- `.book-card` - Book card container with hover effects
- `.verdict-badge` - Verdict indicator (color-coded)
- `.badge-chip` - Small pill-shaped labels
- `.skeleton` - Loading placeholder animation
- `.fade-in` - Entry animation
- `.container` - Max-width centered container
- `.pill` - Filter pill buttons

---

## 🔄 Data Flow Examples

### Example 1: User Browses Books

1. User navigates to `/browse`
2. `HomeComponent.ngOnInit()` calls `loadBooks()`
3. `ApiService.getBooks()` checks cache → miss
4. HTTP GET to `http://localhost:8080/api/v1/books?page=0&size=20`
5. `JwtAuthenticationFilter` passes (public endpoint)
6. `BookController.getBooks()` receives request
7. `BookService.getBooks()` calls `BookRepository.searchAndFilter()`
8. JPA executes SQL query with pagination
9. Results mapped to `Page<BookDTO>`
10. Response sent to frontend
11. `ApiService` caches response
12. `HomeComponent` updates `books` array
13. Template renders book grid

### Example 2: Admin Updates a Book

1. Admin logs in via `/login`
2. `AuthService.login()` POST to `/api/v1/auth/login`
3. Backend validates credentials, returns JWT
4. Frontend stores token in localStorage
5. Admin navigates to `/admin`
6. `authGuard` checks token → allows access
7. Admin clicks "Edit" on a book
8. `AdminBookFormComponent` loads book data
9. Admin modifies fields, clicks "Save"
10. `ApiService.updateBook()` clears cache
11. HTTP PUT to `/api/v1/books/{id}` with `Authorization: Bearer <token>`
12. `JwtAuthenticationFilter` validates token, sets SecurityContext
13. `BookController.updateBook()` receives request
14. `BookService.updateBook()` fetches existing entity
15. Service merges DTO data, clears/rebuilds collections
16. `BookRepository.save()` persists changes
17. Response sent to frontend
18. Admin dashboard reloads book list

### Example 3: User Views Book Detail

1. User clicks book card on landing page
2. Router navigates to `/book/atomic-habits`
3. `BookDetailComponent` activated with `slug = 'atomic-habits'`
4. `ApiService.getBookBySlug()` called
5. HTTP GET to `/api/v1/books/slug/atomic-habits`
6. `BookController.getBookBySlug()` receives request
7. `BookService.getBookBySlug()` calls `BookRepository.findBySlug()`
8. JPA executes `SELECT * FROM books WHERE slug = 'atomic-habits'`
9. Book entity loaded with lazy collections (categories, links, reasons)
10. Mapped to `BookDTO`
11. Response sent to frontend
12. Component renders detail view with tabs

---

## 🚀 Getting Started (Developer Guide)

### Prerequisites
- **Java 17+** installed
- **Maven 3.8+** installed
- **Node.js 20+** installed
- **npm 11+** installed

### Backend Setup

```bash
cd /workspace/ReadWorth

# Install dependencies
mvn clean install

# Run application
mvn spring-boot:run

# Application starts on http://localhost:8080
# H2 console available at http://localhost:8080/h2-console
# JDBC URL: jdbc:h2:mem:readworth
# Username: sa, Password: (blank)
```

**Default Admin Credentials:**
- Username: `admin`
- Password: `admin`

### Frontend Setup

```bash
cd /workspace/readworth-client

# Install dependencies
npm install

# Start development server
npm start

# Application opens at http://localhost:4200
# Auto-reloads on file changes
```

### Running Both Simultaneously

1. Start backend in one terminal:
   ```bash
   cd /workspace/ReadWorth && mvn spring-boot:run
   ```

2. Start frontend in another terminal:
   ```bash
   cd /workspace/readworth-client && npm start
   ```

3. Access app at `http://localhost:4200`

---

## 📡 API Reference

### Authentication

#### POST `/api/v1/auth/login`
**Request:**
```json
{
  "username": "admin",
  "password": "admin"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImlhdCI6MTY5ODc2NTQzMiwiZXhwIjoxNjk4Nzc5ODMyfQ.abc123..."
}
```

---

### Books

#### GET `/api/v1/books`
**Query Params:**
- `query` (optional): Search term
- `categoryId` (optional): Filter by category
- `page` (default: 0): Page number
- `size` (default: 20): Items per page

**Response:**
```json
{
  "content": [
    {
      "id": 1,
      "slug": "atomic-habits",
      "title": "Atomic Habits",
      "authorName": "James Clear",
      "coverImage": "https://...",
      "verdict": "YES",
      "confidencePercentage": 95,
      "ourRating": 5,
      "categories": [{"id": 4, "name": "Self-Help"}],
      ...
    }
  ],
  "totalElements": 8,
  "totalPages": 1,
  "number": 0,
  "size": 20
}
```

#### GET `/api/v1/books/{id}`
**Response:** Single `BookDTO` object

#### GET `/api/v1/books/slug/{slug}`
**Response:** Single `BookDTO` object

#### POST `/api/v1/books`
**Auth Required:** Yes (Bearer token)

**Request:** `BookDTO` object

**Response:** Created `BookDTO`

#### PUT `/api/v1/books/{id}`
**Auth Required:** Yes

**Request:** `BookDTO` object

**Response:** Updated `BookDTO`

#### DELETE `/api/v1/books/{id}`
**Auth Required:** Yes

**Response:** 204 No Content

---

### Categories

#### GET `/api/v1/categories`
**Response:**
```json
[
  {"id": 1, "name": "Business"},
  {"id": 2, "name": "Philosophy"},
  ...
]
```

---

### Feedback

#### POST `/api/v1/feedback`
**Request:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "message": "Great site!"
}
```

**Response:** 200 OK

#### GET `/api/v1/feedback`
**Auth Required:** Yes

**Response:** Array of `Feedback` objects

---

## 🔐 Security Considerations

### Current Implementation
- JWT tokens expire after 4 hours
- Passwords hashed with BCrypt
- CORS restricted to `http://localhost:4200`
- CSRF disabled (stateless API)
- SQL injection prevented via JPA parameterized queries
- Input validation via Jakarta Validation annotations

### Production Recommendations
1. **Environment Variables:**
   - Move `jwt.secret` to environment variable
   - Use different secrets per environment

2. **HTTPS:**
   - Enforce HTTPS in production
   - Update CORS to production domain

3. **Rate Limiting:**
   - Add rate limiting to prevent brute force attacks
   - Consider Spring Boot Rate Limiter or Redis

4. **Password Policy:**
   - Enforce strong password requirements
   - Add password reset functionality

5. **Token Refresh:**
   - Implement refresh token mechanism
   - Reduce access token expiration

6. **Database:**
   - Switch to PostgreSQL in production
   - Enable Flyway migrations
   - Use connection pooling (HikariCP default)

7. **Logging:**
   - Add audit logging for admin actions
   - Sanitize logs to prevent credential leakage

---

## 🧪 Testing

### Backend Tests
```bash
cd /workspace/ReadWorth
mvn test
```

**Test Class:** `ReadWorthApplicationTests.java`

### Frontend Tests
```bash
cd /workspace/readworth-client
npm test
```

**Test Framework:** Vitest with Angular Testing Utilities

---

## 📦 Deployment Considerations

### Backend Deployment
1. **Build JAR:**
   ```bash
   mvn clean package -DskipTests
   ```

2. **Run with Production Profile:**
   ```bash
   java -jar target/ReadWorth-0.0.1-SNAPSHOT.jar \
     --spring.profiles.active=prod \
     --spring.datasource.url=jdbc:postgresql://host:port/dbname \
     --spring.datasource.username=user \
     --spring.datasource.password=pass \
     --jwt.secret=${JWT_SECRET}
   ```

3. **Docker (Optional):**
   - Create Dockerfile with OpenJDK 17 base image
   - Use multi-stage build for smaller image

### Frontend Deployment
1. **Build:**
   ```bash
   npm run build -- --configuration production
   ```

2. **Output:** `dist/readworth-client/` folder

3. **Serve:**
   - Deploy to static hosting (Netlify, Vercel, S3 + CloudFront)
   - Or serve via Nginx/Apache

4. **Environment Configuration:**
   - Update `ApiService.baseUrl` to production API URL
   - Consider using Angular environment files

---

## 🛠️ Common Development Tasks

### Adding a New Book Category
1. Insert into database:
   ```sql
   INSERT INTO categories (name) VALUES ('Science');
   ```
2. Restart backend (or use admin dashboard if CRUD implemented)
3. Frontend automatically picks up new category via `/api/v1/categories`

### Adding a New API Endpoint
**Backend:**
1. Create method in `BookController.java`:
   ```java
   @GetMapping("/featured")
   public ResponseEntity<List<BookDTO>> getFeaturedBooks() {
       return ResponseEntity.ok(bookService.getFeaturedBooks());
   }
   ```
2. Add service method in `BookService.java`
3. Test via Swagger/Postman

**Frontend:**
1. Add method to `ApiService.ts`:
   ```typescript
   getFeaturedBooks(): Observable<Book[]> {
     return this.http.get<Book[]>(`${this.baseUrl}/books/featured`);
   }
   ```
2. Use in component

### Changing JWT Expiration
1. Update `application.yml`:
   ```yaml
   jwt:
     expiration-ms: 28800000  # 8 hours
   ```
2. Restart backend

### Adding a New Field to Book
**Backend:**
1. Add field to `Book.java` entity
2. Add field to `BookDTO.java`
3. Update `BookService.mapToDTO()` and `mapToEntity()`
4. Create Flyway migration for database schema change
5. Update seed data if needed

**Frontend:**
1. Add field to `Book` interface in `models.ts`
2. Update forms/templates as needed

---

## 🐛 Troubleshooting

### Backend Issues

**Problem:** Application won't start
- Check Java version: `java -version` (must be 17+)
- Check Maven: `mvn -version`
- Check for port conflicts: `lsof -i :8080`

**Problem:** Database errors
- H2 console: `http://localhost:8080/h2-console`
- Check `application.yml` datasource configuration
- Verify Flyway migration scripts are valid SQL

**Problem:** JWT validation fails
- Ensure `jwt.secret` is same across restarts
- Check token expiration time
- Verify clock skew between client/server

### Frontend Issues

**Problem:** CORS errors
- Backend must allow `http://localhost:4200`
- Check `SecurityConfig.corsConfigurationSource()`
- Ensure backend is running

**Problem:** HTTP 401 Unauthorized
- Check if token exists in localStorage
- Verify token hasn't expired
- Check `authInterceptor` is registered in `app.config.ts`

**Problem:** Build errors
- Clear node_modules: `rm -rf node_modules && npm install`
- Check TypeScript version compatibility
- Verify Angular CLI version matches project

---

## 📚 Glossary

| Term | Definition |
|------|------------|
| **Verdict** | The final recommendation: YES, NO, or CONDITIONAL |
| **Confidence Score** | Percentage indicating certainty of verdict (0-100%) |
| **ROI** | Return on Investment - value gained vs time spent |
| **Slug** | SEO-friendly URL identifier (e.g., "atomic-habits") |
| **DTO** | Data Transfer Object - shapes API request/response |
| **Entity** | JPA class representing a database table |
| **Repository** | Data access layer interface (extends JpaRepository) |
| **Signal** | Angular's reactive primitive for state management |
| **Interceptor** | HTTP middleware for modifying requests/responses |
| **Guard** | Route protection mechanism |

---

## 📞 Support & Contribution

### Code Style Guidelines

**Backend (Java):**
- Follow Spring Boot conventions
- Use Lombok for boilerplate reduction
- Keep controllers thin, services fat
- Use DTOs for all API boundaries
- Validate input with Jakarta Validation annotations

**Frontend (TypeScript/Angular):**
- Use standalone components (Angular 17+)
- Prefer signals over RxJS BehaviorSubject for local state
- Use async pipe in templates where possible
- Keep components focused (single responsibility)
- Use Tailwind utility classes for styling

### Git Workflow
1. Create feature branch: `git checkout -b feature/your-feature`
2. Commit changes with clear messages
3. Push and create pull request
4. Request code review
5. Merge after approval

---

## 🎯 Summary

**ReadWorth** is a full-stack web application that solves a real problem: helping readers decide which books are worth their limited time. The platform combines thoughtful UX with robust technical implementation:

- **Backend:** Spring Boot REST API with JWT security, JPA/Hibernate ORM, and comprehensive validation
- **Frontend:** Modern Angular SPA with responsive design, caching, and intuitive navigation
- **Database:** Well-normalized schema supporting complex book metadata and relationships
- **Security:** Stateless JWT authentication with proper CORS and input validation
- **Developer Experience:** Clear separation of concerns, comprehensive documentation, easy setup

By reading this document, developers should have a complete understanding of:
- The project's purpose and architecture
- How data flows through the system
- Where to find and modify specific functionality
- How to set up the development environment
- Common patterns and best practices used throughout

This enables team members to start contributing immediately without needing to trace through individual files.
