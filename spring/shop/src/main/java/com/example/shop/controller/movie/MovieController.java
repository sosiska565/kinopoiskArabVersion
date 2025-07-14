package com.example.shop.controller.movie;

import java.net.http.HttpResponse;
import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.shop.repository.movie.Movie;
import com.example.shop.service.movie.MovieService;

@RestController
public class MovieController {
    final MovieService service;

    MovieController(MovieService service){
        this.service = service;
    }
    
    @GetMapping("/api/movies")
    public List<Movie> findAllMovies(){
        return service.findAllMovies();
    }

    @GetMapping("/api/movies/{id}")
    public Optional<Movie> findById(@PathVariable Long id){
        return service.findById(id);
    }

    @GetMapping("/api/movies/search")
    public List<Movie> findAllByUserEmail(@RequestParam String userEmail){
        return service.findAllByUserEmail(userEmail);
    }

    @PostMapping("/api/movies/create")
    public ResponseEntity<Movie> createMovie(@RequestBody Movie movie){
        Movie savedMovie = service.saveMovie(movie);
        
        return new ResponseEntity<>(savedMovie, HttpStatus.CREATED);
    }

    @DeleteMapping("/api/movies/{id}")
    public void deleteMovie(@PathVariable Long id){
        service.deleteMovieById(id);
    }
}
