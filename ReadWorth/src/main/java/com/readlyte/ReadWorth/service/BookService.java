package com.readlyte.ReadWorth.service;

import com.readlyte.ReadWorth.dto.BookDTO;
import com.readlyte.ReadWorth.dto.CategoryDTO;
import com.readlyte.ReadWorth.dto.ExternalLinkDTO;
import com.readlyte.ReadWorth.entity.Book;
import com.readlyte.ReadWorth.entity.Category;
import com.readlyte.ReadWorth.entity.ExternalLink;
import com.readlyte.ReadWorth.repository.BookRepository;
import com.readlyte.ReadWorth.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class BookService {

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    public Page<BookDTO> getBooks(String query, Long categoryId, Pageable pageable) {
        Page<Book> books = bookRepository.searchAndFilter(query, categoryId, pageable);
        return books.map(this::mapToDTO);
    }

    public BookDTO getBookById(Long id) {
        Book book = bookRepository.findById(id).orElseThrow(() -> new RuntimeException("Book not found"));
        return mapToDTO(book);
    }

    public BookDTO getBookBySlug(String slug) {
        Book book = bookRepository.findBySlug(slug)
                .orElseThrow(() -> new RuntimeException("Book not found with slug: " + slug));
        return mapToDTO(book);
    }

    @Transactional
    public BookDTO createBook(BookDTO bookDTO) {
        Book book = mapToEntity(bookDTO, new Book());
        if (book.getSlug() == null || book.getSlug().isBlank()) {
            book.setSlug(generateSlug(book.getTitle()));
        }
        return mapToDTO(bookRepository.save(book));
    }

    @Transactional
    public BookDTO updateBook(Long id, BookDTO bookDTO) {
        Book book = bookRepository.findById(id).orElseThrow(() -> new RuntimeException("Book not found"));
        book = mapToEntity(bookDTO, book);
        if (book.getSlug() == null || book.getSlug().isBlank()) {
            book.setSlug(generateSlug(book.getTitle()));
        }
        return mapToDTO(bookRepository.save(book));
    }

    @Transactional
    public void deleteBook(Long id) {
        bookRepository.deleteById(id);
    }

    /** Convert title → kebab-case slug e.g. "Atomic Habits" → "atomic-habits" */
    public static String generateSlug(String title) {
        if (title == null) return "";
        String normalized = Normalizer.normalize(title, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .trim()
                .replaceAll("\\s+", "-")
                .replaceAll("-{2,}", "-");
    }

    private BookDTO mapToDTO(Book book) {
        BookDTO dto = new BookDTO();
        dto.setId(book.getId());
        dto.setSlug(book.getSlug());
        dto.setTitle(book.getTitle());
        dto.setAuthorName(book.getAuthorName());
        dto.setCoverImage(book.getCoverImage());
        dto.setAboutDescription(book.getAboutDescription());
        dto.setAuthorTrueStory(book.getAuthorTrueStory());
        dto.setDifficultyLevel(book.getDifficultyLevel());
        dto.setLengthLabel(book.getLengthLabel());
        dto.setLanguageTone(book.getLanguageTone());
        dto.setWhatToExpect(book.getWhatToExpect());
        dto.setHowNotToJudge(book.getHowNotToJudge());
        dto.setExpectedOutcome(book.getExpectedOutcome());
        dto.setExpectedTimeInvestment(book.getExpectedTimeInvestment());
        dto.setOurRating(book.getOurRating());
        dto.setVerdict(book.getVerdict());
        dto.setConfidencePercentage(book.getConfidencePercentage());
        dto.setVerdictReasons(new ArrayList<>(book.getVerdictReasons()));
        dto.setEstimatedRoi(book.getEstimatedRoi());

        if (book.getCategories() != null) {
            dto.setCategories(book.getCategories().stream().map(c -> {
                CategoryDTO cd = new CategoryDTO();
                cd.setId(c.getId());
                cd.setName(c.getName());
                return cd;
            }).collect(Collectors.toList()));
            dto.setCategoryIds(book.getCategories().stream().map(Category::getId).collect(Collectors.toList()));
        }

        if (book.getExternalLinks() != null) {
            dto.setExternalLinks(book.getExternalLinks().stream().map(l -> {
                ExternalLinkDTO ld = new ExternalLinkDTO();
                ld.setId(l.getId());
                ld.setLabel(l.getLabel());
                ld.setUrl(l.getUrl());
                return ld;
            }).collect(Collectors.toList()));
        }
        return dto;
    }

    private Book mapToEntity(BookDTO dto, Book book) {
        book.setTitle(dto.getTitle());
        if (dto.getSlug() != null && !dto.getSlug().isBlank()) {
            book.setSlug(dto.getSlug());
        }
        book.setAuthorName(dto.getAuthorName());
        book.setCoverImage(dto.getCoverImage());
        book.setAboutDescription(dto.getAboutDescription());
        book.setAuthorTrueStory(dto.getAuthorTrueStory());
        book.setDifficultyLevel(dto.getDifficultyLevel());
        book.setLengthLabel(dto.getLengthLabel());
        book.setLanguageTone(dto.getLanguageTone());
        book.setWhatToExpect(dto.getWhatToExpect());
        book.setHowNotToJudge(dto.getHowNotToJudge());
        book.setExpectedOutcome(dto.getExpectedOutcome());
        book.setExpectedTimeInvestment(dto.getExpectedTimeInvestment());
        book.setOurRating(dto.getOurRating());
        book.setVerdict(dto.getVerdict());
        book.setConfidencePercentage(dto.getConfidencePercentage());

        book.getVerdictReasons().clear();
        if (dto.getVerdictReasons() != null) {
            book.getVerdictReasons().addAll(dto.getVerdictReasons());
        }

        book.setEstimatedRoi(dto.getEstimatedRoi());

        Set<Category> categories = new HashSet<>();
        if (dto.getCategoryIds() != null) {
            for (Long cid : dto.getCategoryIds()) {
                categories.add(categoryRepository.findById(cid).orElseThrow());
            }
        }
        book.setCategories(categories);

        if (book.getExternalLinks() != null) {
            book.getExternalLinks().clear();
        } else {
            book.setExternalLinks(new ArrayList<>());
        }

        if (dto.getExternalLinks() != null) {
            for (ExternalLinkDTO linkDTO : dto.getExternalLinks()) {
                ExternalLink link = new ExternalLink();
                link.setLabel(linkDTO.getLabel());
                link.setUrl(linkDTO.getUrl());
                book.addExternalLink(link);
            }
        }

        return book;
    }
}
