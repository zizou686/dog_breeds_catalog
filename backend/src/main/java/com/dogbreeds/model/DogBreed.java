package com.dogbreeds.model;

import jakarta.persistence.*;

@Entity
@Table(name = "dog_breeds")
public class DogBreed {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String origin;
    
    @Column(length = 500)
    private String temperament;
    
    @Column(nullable = false)
    private String size;
    
    @Column(name = "life_span")
    private String lifeSpan;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "image_url")
    private String imageUrl;
    
    // Constructores
    public DogBreed() {}
    
    public DogBreed(String name, String origin, String temperament, String size, String lifeSpan, String description) {
        this.name = name;
        this.origin = origin;
        this.temperament = temperament;
        this.size = size;
        this.lifeSpan = lifeSpan;
        this.description = description;
    }
    
    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }
    
    public String getTemperament() { return temperament; }
    public void setTemperament(String temperament) { this.temperament = temperament; }
    
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    
    public String getLifeSpan() { return lifeSpan; }
    public void setLifeSpan(String lifeSpan) { this.lifeSpan = lifeSpan; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
