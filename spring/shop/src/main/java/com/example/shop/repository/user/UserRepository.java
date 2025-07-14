package com.example.shop.repository.user;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    public boolean existsByName(String name);

    public boolean existsByEmail(String email);

    public Optional<User> findByEmail(String email);
}
