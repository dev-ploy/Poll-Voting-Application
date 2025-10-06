package com.voting.votingapp.repo;

import com.voting.votingapp.model.Poll;
import lombok.Lombok;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PollingRepo extends JpaRepository<Poll, Lombok> {
    Optional<Poll> findById(Long id);
}
