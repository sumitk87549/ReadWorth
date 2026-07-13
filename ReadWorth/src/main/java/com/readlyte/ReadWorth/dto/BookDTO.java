package com.readlyte.ReadWorth.dto;

import com.readlyte.ReadWorth.entity.DifficultyLevel;
import com.readlyte.ReadWorth.entity.Verdict;
import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.List;

@Data
public class BookDTO {
    private Long id;
    private String slug;

    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Author is required")
    private String authorName;

    private String coverImage;
    private String aboutDescription;
    private String authorTrueStory;
    private List<Long> categoryIds; // Instead of full category objects for input
    private List<CategoryDTO> categories; // For output
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
