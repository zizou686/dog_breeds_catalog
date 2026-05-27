package com.dogbreeds.controller;

import com.dogbreeds.dto.LoginRequest;
import com.dogbreeds.dto.RegisterRequest;
import com.dogbreeds.model.User;
import com.dogbreeds.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "El email ya está registrado");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
        }
        
        User user = new User();
        user.setEmail(request.email());
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setFirstName(request.firstName());
        user.setLastName(request.lastName());
        user.setActive(true);
        
        User saved = userRepository.save(user);
        
        Map<String, Object> response = new HashMap<>();
        response.put("id", saved.getId());
        response.put("email", saved.getEmail());
        response.put("firstName", saved.getFirstName());
        response.put("lastName", saved.getLastName());
        response.put("message", "Usuario registrado correctamente");
        
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        Optional<User> user = userRepository.findByEmail(request.email());
        
        if (user.isPresent() && passwordEncoder.matches(request.password(), user.get().getPassword())) {
            Map<String, Object> response = new HashMap<>();
            response.put("id", user.get().getId());
            response.put("email", user.get().getEmail());
            response.put("firstName", user.get().getFirstName());
            response.put("lastName", user.get().getLastName());
            response.put("token", "bearer_token_" + System.currentTimeMillis());
            return ResponseEntity.ok(response);
        }
        
        Map<String, String> error = new HashMap<>();
        error.put("error", "Email o contraseña incorrectos");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
    }
}
