package com.example.shop.controller.user;

import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.shop.repository.user.User;
import com.example.shop.service.user.UserService;

import jakarta.websocket.server.PathParam;

@RestController
public class UserController {
    private final UserService service;

    public UserController(UserService service){
        this.service = service;
    }

    @GetMapping("/api/users")
    public List<User> findAllUsers(){
        return service.findAllUsers();
    }

    @GetMapping("/api/users/{id}")
    public Optional<User> findById(@PathVariable Long id){
        return service.findById(id);
    }

    @GetMapping("/api/users/search")
    public ResponseEntity<User> findByEmail(@RequestParam String email){
        return service.findByEmail(email)
            .map(user -> new ResponseEntity<>(user, HttpStatus.OK))
            .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping("/api/users/create")
    public ResponseEntity<User> createUser(@RequestBody User user){
        User savedUser = service.saveUser(user);

        return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
    }

    @PutMapping("api/users/{id}")
    public User updateUser(
        @PathVariable Long id,
        @RequestParam(required = false) String name,
        @RequestParam(required = false) String nickname,
        @RequestParam(required = false) String password,
        @RequestParam(required = false) String email
    ){
        return service.update(id, name, nickname, password, email);
    }

    @DeleteMapping("/api/users/{id}")
    public void deleteById(@PathVariable Long id){
        service.deleteById(id);
    }
}
