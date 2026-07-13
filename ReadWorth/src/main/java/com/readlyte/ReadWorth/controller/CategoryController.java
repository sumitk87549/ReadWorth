package com.readlyte.ReadWorth.controller;

import com.readlyte.ReadWorth.dto.CategoryDTO;
import com.readlyte.ReadWorth.entity.Category;
import com.readlyte.ReadWorth.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/categories")
public class CategoryController {

    @Autowired
    private CategoryRepository categoryRepository;

    @GetMapping
    public ResponseEntity<List<CategoryDTO>> getCategories() {
        List<CategoryDTO> categories = categoryRepository.findAll().stream().map(c -> {
            CategoryDTO dto = new CategoryDTO();
            dto.setId(c.getId());
            dto.setName(c.getName());
            return dto;
        }).collect(Collectors.toList());
        
        return ResponseEntity.ok(categories);
    }
}
