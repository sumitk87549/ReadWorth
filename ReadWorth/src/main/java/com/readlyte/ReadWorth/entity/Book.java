package com.readlyte.ReadWorth.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

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
    private String slug;

    @Column(nullable = false)
    private String authorName;

    @Column(length = 1024)
    private String coverImage;

    @Column(columnDefinition = "TEXT")
    private String aboutDescription;

    @Column(columnDefinition = "TEXT")
    private String authorTrueStory;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "book_categories",
        joinColumns = @JoinColumn(name = "book_id"),
        inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private Set<Category> categories = new HashSet<>();

    @Enumerated(EnumType.STRING)
    private DifficultyLevel difficultyLevel;

    private String lengthLabel; // e.g., "300 pages", "Short read"

    private String languageTone;

    @Column(columnDefinition = "TEXT")
    private String whatToExpect;

    @Column(columnDefinition = "TEXT")
    private String howNotToJudge;

    @Column(columnDefinition = "TEXT")
    private String expectedOutcome;

    private Double expectedTimeInvestment; // in hours

    private Integer ourRating; // 1-5

    @Enumerated(EnumType.STRING)
    private Verdict verdict;

    private Integer confidencePercentage;

    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "book_verdict_reasons", joinColumns = @JoinColumn(name = "book_id"))
    @Column(name = "reason", columnDefinition = "TEXT")
    private List<String> verdictReasons = new ArrayList<>();

    private String estimatedRoi;

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<ExternalLink> externalLinks = new ArrayList<>();

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public void addExternalLink(ExternalLink link) {
        externalLinks.add(link);
        link.setBook(this);
    }

    public void removeExternalLink(ExternalLink link) {
        externalLinks.remove(link);
        link.setBook(null);
    }
}
