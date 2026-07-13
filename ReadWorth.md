# ReadWorth - Project Technical Documentation

Welcome to the technical documentation for **ReadWorth**. This document serves as the "golden key" for any technical staff or developer joining the project. After reading this, you will have a comprehensive understanding of the project's architecture, domain model, directory structure, and technical stack. 

---

## 1. Project Overview & Purpose
**ReadWorth** is a pre-reading web platform that helps users decide whether to invest their time in reading a specific book. Instead of standard user reviews, ReadWorth provides structured, analytical insights into a book's true contents. 

Key features include:
*   **What to Expect / How Not to Judge:** Managing reader expectations.
*   **Difficulty & Tone:** Assessing the writing style.
*   **Expected Outcome & ROI:** Evaluating the potential benefit to the reader.
*   **Verdict (YES / NO / CONDITIONAL) & Rating:** A final score indicating if the book is worth reading.

---

## 2. Tech Stack Architecture

ReadWorth is built using a modern full-stack architecture separated into a backend API and a frontend client.

### Backend (Spring Boot)
*   **Framework:** Spring Boot (Java 17).
*   **Data Access:** Spring Data JPA / Hibernate.
*   **Database:** H2 (In-memory database used for development, seeded on startup). Also configured for PostgreSQL.
*   **Security:** Spring Security with stateless JWT (JSON Web Token) authentication.
*   **Migrations:** Flyway (available for managing schema changes).
*   **Build Tool:** Maven (`pom.xml`).

### Frontend (Angular)
*   **Framework:** Angular v21.1.
*   **Styling:** TailwindCSS v4.1 (Utility-first CSS framework).
*   **State / Reactivity:** RxJS (Observables).
*   **Routing:** Angular Router (SPA - Single Page Application).
*   **Build Tool:** Angular CLI / npm (`package.json`).

---

## 3. Directory Structure & File-Wise Functionality

The project consists of two main root directories: `ReadWorth` (backend) and `readworth-client` (frontend).

### 3.1 Backend: `ReadWorth/`

Navigate to `src/main/java/com/readlyte/ReadWorth/` for the core Java packages:

*   **`controller/`**: Contains the REST API endpoints. This is the entry point for frontend requests.
    *   `AuthController.java`: Handles admin login and JWT generation.
    *   `BookController.java`: CRUD operations for books.
    *   `CategoryController.java`: Fetches book categories.
    *   `FeedbackController.java`: Handles user feedback submissions.
*   **`entity/`**: The JPA Entities representing database tables. The core domain logic lives here.
    *   `Book.java`: The central entity. Contains extensive metadata fields (title, expected outcome, verdict, rating, difficulty level).
    *   `Category.java`: Categories linked to books (Many-to-Many).
    *   `AdminUser.java`: Stores credentials for dashboard access.
    *   `Feedback.java`: User-submitted feedback.
*   **`dto/`**: Data Transfer Objects used to transfer data safely without exposing raw database entities.
*   **`repository/`**: Interfaces extending `JpaRepository`. Spring Boot automatically provides the SQL implementation to talk to the DB.
*   **`service/`**: The business logic layer (e.g., `BookService.java`). Controllers call services, which in turn call repositories.
*   **`security/`**: Configuration for Spring Security and JWT authentication filters.
*   **`exception/`**: Global error handling classes to ensure standard API error responses.

Navigate to `src/main/resources/`:
*   **`application.yml`**: Central backend configuration (Server port 8080, DB connection strings, JWT secret).
*   **`data.sql`**: Seed data script. Since H2 is an in-memory DB, this script populates the database with initial books and an admin user every time the backend boots.
*   **`db/migration/`**: Contains SQL scripts used if Flyway is enabled to track DB versioning.

### 3.2 Frontend: `readworth-client/`

Navigate to `src/app/` for the core Angular code:

*   **`app.routes.ts`**: The central routing file defining what component renders on what URL.
    *   `/` -> `LandingComponent`
    *   `/browse` -> `HomeComponent` (The main library/grid)
    *   `/book/:slug` -> `BookDetailComponent` (SEO friendly detailed book view)
    *   `/admin` -> `AdminDashboardComponent` (Protected by `authGuard`)
*   **`models.ts`**: TypeScript interfaces that perfectly mirror the backend DTOs/Entities (e.g., `Book`, `Category`, `Feedback`).
*   **`components/`**: The visual UI building blocks of the platform.
    *   `landing/`, `home/`, `book-detail/`: User-facing pages.
    *   `admin-dashboard/`, `admin-book-form/`, `admin-login/`: CMS components for managing the platform contents.
*   **`services/`**: Handling API calls and global application state.
    *   `api.service.ts`: Central service utilizing Angular's `HttpClient` to communicate with the Spring backend (on `http://localhost:8080/api/v1`). Implements basic caching for performance.
    *   `auth.service.ts`: Handles JWT token storage and verification for the admin panel.
    *   `theme.service.ts`: Handles light/dark mode toggling.

---

## 4. Security & Authentication Model

*   **Public API:** GET requests for books and categories, and POST requests for feedback are public.
*   **Protected API:** POST/PUT/DELETE operations for books require admin privileges.
*   **Flow:** The admin logs in via `/login` on the UI. The Angular client sends credentials to `AuthController`. The backend verifies and returns a **JWT**. The Angular `auth.service.ts` stores this token and attaches it via an HTTP Interceptor to all subsequent protected requests.

---

## 5. Developer Guide: How to Run Locally

### Starting the Backend
1. Open a terminal and navigate to the backend folder: `cd ReadWorth`
2. Run the application using the Maven wrapper: `./mvnw spring-boot:run`
3. The server will start on `http://localhost:8080`. (The H2 database is fresh on every restart, populated by `data.sql`).

### Starting the Frontend
1. Open a new terminal and navigate to the frontend folder: `cd readworth-client`
2. Install dependencies (if first time): `npm install`
3. Start the Angular development server: `npm start` (or `ng serve`)
4. Access the web app in your browser at `http://localhost:4200/`.

---

## 6. How to Add a New Feature (Example: Adding a New Field to Book)

If you are a developer looking to extend the platform by adding a new field (e.g., "targetAudience"), follow this workflow:

1.  **Backend Entity:** Add `private String targetAudience;` to `Book.java`. Generate getters/setters (or let Lombok handle it).
2.  **Backend Seed:** Update `data.sql` to include the `targetAudience` column in the `INSERT INTO book` statements.
3.  **Frontend Model:** Add `targetAudience?: string;` to the `Book` interface in `models.ts`.
4.  **Frontend CMS:** Update the HTML and TypeScript in `admin-book-form` to provide an input field for the admin to save this data.
5.  **Frontend View:** Update the HTML in `book-detail` to render the `targetAudience` to the end-user.
