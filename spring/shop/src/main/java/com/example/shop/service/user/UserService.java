package com.example.shop.service.user;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.shop.repository.user.User;
import com.example.shop.repository.user.UserRepository;

@Service
public class UserService {
    private final UserRepository repository;

    public UserService(UserRepository repository){
        this.repository = repository;
    }

    public List<User> findAllUsers(){
        return repository.findAll();
    }

    public Optional<User> findById(Long id){
        Optional user = repository.findById(id);

        if(user.isPresent()){
            return user;
        }
        else{
            throw new IllegalArgumentException("user with id not found.");
        }
    }

    public Optional<User> findByEmail(String email){
        Optional user = repository.findByEmail(email);

        if(user.isPresent()){
            return user;
        }
        else{
            throw new IllegalArgumentException("user with number not found.");
        }
    }

    public User saveUser(User user){
        if(user.getName() == null || user.getNickname() == null || user.getEmail() == null || user.getPassword() == null){
            throw new IllegalArgumentException("please fill all fields");
        }
        
        if(repository.existsByEmail(user.getEmail())){
            throw new IllegalArgumentException("user is already exists");
        }
        else{
            return repository.save(user);
        }
    }

    public User update(Long id, String name, String nickname, String password, String email){
        Optional<User> optionalUser = repository.findById(id);
        if(optionalUser.isEmpty()){
            throw new IllegalArgumentException("user with id not found.");
        }

        User user = optionalUser.get();

        if (email != null && !email.equals(user.getEmail())) {
            if (repository.findByEmail(email).isPresent()) {
                throw new IllegalArgumentException("User with this number already exists");
            }
        }

        if (name != null && !name.equals(user.getName())) {
            user.setName(name);
        }
        if (nickname != null && !nickname.equals(user.getNickname())) {
            user.setNickname(nickname);
        }
        if (password != null && !password.equals(user.getPassword())) {
            user.setPassword(password);
        }
        if (email != null && !email.equals(user.getEmail())) {
            user.setEmail(email);
        }

        return repository.save(user);
    }

    public void deleteById(Long id){
        if(!repository.existsById(id)){
            throw new IllegalArgumentException("user with id not found.");
        }
        else{
            repository.deleteById(id);
        }
    }
}
