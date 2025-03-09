package trex.hackathon.smart_prep.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import trex.hackathon.smart_prep.model.User;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository< User, Long> {
	Optional<User> findByUsername(String username);
	Optional<User> findByEmail(String email);
	boolean existsByUsername(String username);
	boolean existsByEmail(String email);
}
