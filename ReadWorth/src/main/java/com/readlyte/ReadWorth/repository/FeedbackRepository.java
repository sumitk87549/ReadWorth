package com.readlyte.ReadWorth.repository;

import com.readlyte.ReadWorth.entity.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FeedbackRepository extends JpaRepository<Feedback, Long> {
}
