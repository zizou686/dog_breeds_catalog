package com.dogbreeds.controller;

import com.dogbreeds.model.DogBreed;
import com.dogbreeds.repository.DogBreedRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/dog-breeds")
public class DogBreedController {
    
    @Autowired
    private DogBreedRepository dogBreedRepository;
    
    @GetMapping
    public ResponseEntity<List<DogBreed>> getAllBreeds() {
        return ResponseEntity.ok(dogBreedRepository.findAll());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<DogBreed> getBreedById(@PathVariable Long id) {
        Optional<DogBreed> breed = dogBreedRepository.findById(id);
        return breed.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public ResponseEntity<DogBreed> createBreed(@RequestBody DogBreed dogBreed) {
        DogBreed saved = dogBreedRepository.save(dogBreed);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<DogBreed> updateBreed(@PathVariable Long id, @RequestBody DogBreed dogBreed) {
        Optional<DogBreed> existing = dogBreedRepository.findById(id);
        if (existing.isPresent()) {
            dogBreed.setId(id);
            return ResponseEntity.ok(dogBreedRepository.save(dogBreed));
        }
        return ResponseEntity.notFound().build();
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBreed(@PathVariable Long id) {
        if (dogBreedRepository.existsById(id)) {
            dogBreedRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
