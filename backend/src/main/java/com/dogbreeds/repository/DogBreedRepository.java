package com.dogbreeds.repository;

import com.dogbreeds.model.DogBreed;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DogBreedRepository extends JpaRepository<DogBreed, Long> {
    DogBreed findByNameIgnoreCase(String name);
}
