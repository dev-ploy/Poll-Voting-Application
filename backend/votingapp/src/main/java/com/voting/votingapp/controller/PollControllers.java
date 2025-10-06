package com.voting.votingapp.controller;

import com.voting.votingapp.model.Poll;
import com.voting.votingapp.request.Vote;
import com.voting.votingapp.service.PollService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

        import java.util.List;

@RestController
@RequestMapping("/api/polls")
@CrossOrigin(origins = "http://localhost:4200")
public class PollControllers {
    private final PollService pollService;
    public PollControllers(PollService pollService) {
        this.pollService = pollService;
    }
    @PostMapping
    public Poll createPoll(@RequestBody Poll poll){
        return pollService.createPoll(poll);
    }
    @GetMapping("/{id}")
    public ResponseEntity<Poll> getPoll(@PathVariable Long id){

        return pollService.getPollById(id).
                map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    //POST
    //VOTE
    //->service
    @PostMapping("/vote")
    public void vote(@RequestBody Vote vote){
        pollService.vote(vote.getPollId(),vote.getOptionIndex());
    }
    @GetMapping
    public List<Poll> getAllPolls(){
        return pollService.getAllPolls();
    }
}
