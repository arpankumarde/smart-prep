import 'package:flutter/material.dart';
import 'package:smart_prep/common/app_theme.dart';

class LoginField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  const LoginField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && !_isVisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppTheme.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppTheme.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 18),
          suffixIcon: widget.isPassword
              ? IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(right: 12),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.gradient2,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
