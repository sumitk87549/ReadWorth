package com.readlyte.ReadWorth.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

@Data
public class ExternalLinkDTO {
    private Long id;

    @NotBlank(message = "Label is required")
    private String label;

    @NotBlank(message = "URL is required")
    private String url;
}
