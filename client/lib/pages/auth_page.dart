import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/pages/students/students_question_paper_list_page.dart';
import 'package:smart_prep/pages/teacher/teacher_question_bank_list_page.dart';
import 'package:smart_prep/providers/auth_provider.dart';
import 'package:smart_prep/widgets/gradient_button.dart';
import 'package:smart_prep/widgets/login_field.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLogin = true;
  bool _isTeacher = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await ref.read(authProvider.notifier).login(
          usernameOrEmail: _emailController.text.trimRight(),
          password: _passwordController.text.trimRight(),
        );
  }

  Future<void> _register() async {
    await ref.read(authProvider.notifier).register(
          name: _nameController.text.trimRight(),
          username: _usernameController.text.trimRight(),
          email: _emailController.text.trimRight(),
          password: _passwordController.text.trimRight(),
          role: _isTeacher ? 'ROLE_TEACHER' : 'ROLE_STUDENT',
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    if (authState.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/bg.png'),
                Text(
                  _isLogin ? 'Sign in' : 'Sign up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(height: 65),
                if (!_isLogin)
                  LoginField(
                    hintText: 'Name',
                    controller: _nameController,
                  ),
                if (!_isLogin) const SizedBox(height: 15),
                if (!_isLogin)
                  LoginField(
                    hintText: 'Username',
                    controller: _usernameController,
                  ),
                if (!_isLogin) const SizedBox(height: 15),
                LoginField(
                  hintText: 'Email',
                  controller: _emailController,
                ),
                const SizedBox(height: 15),
                LoginField(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                if (!_isLogin)
                  Row(
                    children: [
                      Checkbox.adaptive(
                        value: _isTeacher,
                        onChanged: (val) {
                          setState(() {
                            _isTeacher = val!;
                          });
                        },
                        activeColor: AppTheme.gradient2,
                      ),
                      Text(
                        'Sign up as a teacher?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin
                          ? 'Don\'t have an account? '
                          : 'Already have an account? ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Sign up' : 'Sign in',
                        style: TextStyle(
                          color: AppTheme.gradient2,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                GradientButton(
                  text: _isLogin ? 'Sign in' : 'Sign up',
                  onPressed: () async {
                    try {
                      if (_isLogin) {
                        await _login();
                      } else {
                        await _register();
                      }

                      if (mounted) {
                        final authState = ref.read(authProvider);
                        if (authState.user != null && authState.token != null) {
                          if (authState.user!.role == "ROLE_TEACHER") {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    TeacherQuestionBankListPage(),
                              ),
                            );
                          } else if (authState.user!.role == "ROLE_STUDENT") {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    StudentsQuestionPaperListPage(),
                              ),
                            );
                          }
                        } else if (authState.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                authState.error!,
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
