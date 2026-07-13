package com.readlyte.ReadWorth.controller;

import com.readlyte.ReadWorth.dto.FeedbackDTO;
import com.readlyte.ReadWorth.entity.Feedback;
import com.readlyte.ReadWorth.repository.FeedbackRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/feedback")
public class FeedbackController {

    @Autowired
    private FeedbackRepository feedbackRepository;

    @PostMapping
    public ResponseEntity<Void> submitFeedback(@Valid @RequestBody FeedbackDTO feedbackDTO) {
        Feedback feedback = new Feedback();
        feedback.setName(feedbackDTO.getName());
        feedback.setEmail(feedbackDTO.getEmail());
        feedback.setMessage(feedbackDTO.getMessage());
        feedbackRepository.save(feedback);
        return ResponseEntity.ok().build();
    }

    /** Admin-only: list all feedback submissions */
    @GetMapping
    public ResponseEntity<List<Feedback>> getAllFeedback() {
        return ResponseEntity.ok(feedbackRepository.findAll());
    }
}
