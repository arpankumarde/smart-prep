import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/models/user_model.dart';
import 'package:smart_prep/services/auth_services.dart';

class AuthState {
  final bool isLoading;
  final String? token;
  final UserModel? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.token,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    String? token,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthServices _authServices;

  AuthNotifier(this._authServices) : super(AuthState());

  Future<void> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authServices.registerUser(
        name,
        username,
        email,
        password,
        role,
      );

      state = state.copyWith(
        isLoading: false,
        token: response['token'],
        user: response['user'],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authServices.loginUser(
        usernameOrEmail,
        password,
      );

      state = state.copyWith(
        isLoading: false,
        token: response['token'],
        user: response['user'],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> getCurrentUser() async {
    if (state.token == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authServices.getCurrentUser(state.token!);
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<UserModel?> getUserById(int userId) async {
    if (state.token == null) return null;

    try {
      return await _authServices.getUserById(state.token!, userId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAllUsers(
      {int page = 0, int size = 10}) async {
    if (state.token == null) return null;

    try {
      return await _authServices.getAllUsers(
        state.token!,
        page: page,
        size: size,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  bool get isAuthenticated => state.token != null && state.user != null;
  bool get isTeacher => state.user?.role == 'ROLE_TEACHER';
  bool get isStudent => state.user?.role == 'ROLE_STUDENT';
}

final authServicesProvider = Provider((ref) => AuthServices());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authServices = ref.watch(authServicesProvider);
  return AuthNotifier(authServices);
});
