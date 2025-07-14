package com.example.shop.service.movie;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.shop.repository.movie.Movie;
import com.example.shop.repository.movie.MovieRepository;

@Service
public class MovieService {
    final MovieRepository repository;

    MovieService(MovieRepository repository){
        this.repository = repository;
    }


    public List<Movie> findAllMovies(){
        return repository.findAll();
    }

    public Optional<Movie> findById(Long id){
        if(!repository.existsById(id)){
            throw new IllegalArgumentException("movie by id not found.");
        }
        else{
            return repository.findById(id);
        }
    }

    public List<Movie> findAllByUserEmail(String userEmail){
        if(userEmail.isEmpty()){
            throw new IllegalArgumentException("userEmail cannot be empty");
        }
        else{
            return repository.findAllMoviesByUserEmail(userEmail);
        }
    }

    public Movie saveMovie(Movie movie){
        if(movie.getName() == null || movie.getDescription() == null || movie.getPosterUrl() == null){
            throw new IllegalArgumentException("fill all fields");
        }
        else if(repository.existsById(movie.getId())){
            throw new IllegalArgumentException("movie is already exists");
        }
        else{
            return repository.save(movie);
        }
    }

    public void deleteMovieById(Long id){
        if(!repository.existsById(id)){
            throw new IllegalArgumentException("movie not exists.");
        }
        else{
            repository.deleteById(id);
        }
    }
}
