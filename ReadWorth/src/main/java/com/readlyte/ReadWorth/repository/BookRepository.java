package com.readlyte.ReadWorth.repository;

import com.readlyte.ReadWorth.entity.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface BookRepository extends JpaRepository<Book, Long> {

    Optional<Book> findBySlug(String slug);

    @Query("SELECT b FROM Book b LEFT JOIN b.categories c WHERE " +
           "(:query IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(b.authorName) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
           "(:categoryId IS NULL OR c.id = :categoryId)")
    Page<Book> searchAndFilter(@Param("query") String query, @Param("categoryId") Long categoryId, Pageable pageable);
}
