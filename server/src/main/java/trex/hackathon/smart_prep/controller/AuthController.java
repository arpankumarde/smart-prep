package trex.hackathon.smart_prep.controller;

//import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import trex.hackathon.smart_prep.dto.request.LoginRequest;
import trex.hackathon.smart_prep.dto.request.RegisterRequest;
import trex.hackathon.smart_prep.dto.response.AuthResponse;
import trex.hackathon.smart_prep.service.AuthService;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

	private final AuthService authService;

	@PostMapping("/register")
	public ResponseEntity<AuthResponse> register( @RequestBody RegisterRequest request) {
		return ResponseEntity.ok(authService.register(request));
	}

	@PostMapping("/login")
	public ResponseEntity<AuthResponse> login( @RequestBody LoginRequest request) {
		return ResponseEntity.ok(authService.login(request));
	}
}