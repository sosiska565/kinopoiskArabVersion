package com.example.shop.repository.movie;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "Movie")
public class Movie {
    @Id
    private Long id;
    private String name;
    private int year;
    @Column(columnDefinition = "TEXT")
    private String description;
    private double ratingKp;
    @Column(columnDefinition = "TEXT")
    private String posterUrl;
    private boolean isStar = false;
    private String userEmail;
}
