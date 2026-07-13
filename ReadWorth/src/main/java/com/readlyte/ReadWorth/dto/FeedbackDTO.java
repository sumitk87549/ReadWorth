package com.readlyte.ReadWorth.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

@Data
public class FeedbackDTO {
    private String name;
    private String email;

    @NotBlank(message = "Message is required")
    private String message;
}
