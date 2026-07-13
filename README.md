# ReadWorth

Decision-first book review platform.

## Architecture

- **Backend**: Spring Boot 3, Spring Security, JWT Auth, Spring Data JPA, Flyway, PostgreSQL.
- **Frontend**: Angular 17+ (standalone components), Tailwind CSS v4, custom theming.

## Prerequisites

- Java 21+
- Node.js 20+
- PostgreSQL 15+

## Setup & Running

### 1. Database (PostgreSQL)

You can run PostgreSQL locally or via Docker:

```bash
# Using Docker
docker run --name readworth-db -e POSTGRES_DB=readworth -e POSTGRES_USER=rw_user -e POSTGRES_PASSWORD=rw_password -p 5432:5432 -d postgres:15
```

If running locally, ensure you have a database named `readworth` and credentials matching those in `ReadWorth/src/main/resources/application.yml`.

### 2. Backend (Spring Boot)

The application automatically runs Flyway migrations on startup, which will create the schema and seed 8 fully-detailed books and an admin user.

Navigate to the backend directory and run:

```bash
cd ReadWorth
./mvnw spring-boot:run
```

The API will be available at `http://localhost:8080/api/v1`.

### 3. Frontend (Angular)

Navigate to the frontend directory, install dependencies, and start the development server:

```bash
cd readworth-client
npm install
npm start
```

The application will be available at `http://localhost:4200`.

## Features Implemented

- **Editorial Visual Identity**: Uses Playfair Display (Serif) for headings and Inter (Sans-Serif) for body text. Built with Tailwind CSS.
- **Day/Night Mode**: Bespoke dark oak theme vs warm cream light theme.
- **Authentication**: JWT-based authentication for Admin access.
- **Seeded Data**: 8 actual books with detailed verdicts.

## Design Decisions & Notes

- **Token Expiry**: JWT token expiry is set to 4 hours in `application.yml`. This provides a good balance between security and admin convenience for a session-based workflow.
- **Storage**: The JWT is stored in `localStorage` in the frontend for MVP simplicity and persistence across tabs. In a highly secure production environment, this could be migrated to HttpOnly cookies.
- **Data Model**: Implemented using Spring Data JPA. The `categories` and `external_links` are managed via related tables to ensure the schema is properly normalized.
- **Verdict System**: The verdict block is heavily emphasized in the UI, separating "Why?", "Confidence", "Time Invested", and "ROI".
- **Tailwind v4**: Using the new Tailwind v4 setup without a `tailwind.config.js`, variables are managed directly in `styles.css` using `@theme`.