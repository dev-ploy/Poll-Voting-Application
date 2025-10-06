package com.voting.votingapp.service;

import com.voting.votingapp.model.OptionVote;
import com.voting.votingapp.model.Poll;
import com.voting.votingapp.repo.PollingRepo;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PollService {
    private final PollingRepo pollRepo;
    public PollService(PollingRepo pollRepo) {
        this.pollRepo = pollRepo;
    }
    public Poll createPoll(Poll poll) {
        return pollRepo.save(poll);
    }

    public List<Poll> getAllPolls() {
        return pollRepo.findAll();
    }

    public Optional<Poll> getPollById(Long id) {
        return pollRepo.findById(id);
    }

    public void vote(Long pollId, int optionIndex) {
        // get poll from db
        Poll poll=pollRepo.findById(pollId)
                .orElseThrow(()->new RuntimeException("poll not found"));
        // get all options
        List<OptionVote>options= poll.getOptions();
        //if index for vote is not valid throw error
        if(optionIndex<0 || optionIndex>=options.size()){
            throw new IllegalArgumentException("invalid option index");
        }
        // get selected option
        OptionVote selectedOption=options.get(optionIndex);
        // increment vote for selected option
        selectedOption.setVoteCount(selectedOption.getVoteCount()+1);
        //save incremented vote option into the database
        pollRepo.save(poll);
    }
}
