package com.readlyte.ReadWorth.repository;

import com.readlyte.ReadWorth.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Category findByName(String name);
}
