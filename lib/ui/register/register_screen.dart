import 'package:flutter/material.dart';
import 'package:todo_app/ui/common/custom_text_form_field.dart';
import 'package:todo_app/ui/login/login_screen.dart';
import 'package:todo_app/ui/utils/validation_utils.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState?.validate() == true) {
      // Form is valid - ready for Firebase / backend integration later
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Navigating to Login...'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004182),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Route Logo
                Center(
                  child: Image.asset(
                    'assets/Route_Logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'Route',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 35),

                // Full Name Field
                CustomTextFormField(
                  label: 'Full Name',
                  hintText: 'enter your full name',
                  controller: _fullNameController,
                  validator: AppValidator.validateFullName,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),

                // Mobile Number Field
                CustomTextFormField(
                  label: 'Mobile Number',
                  hintText: 'enter your mobile no.',
                  controller: _mobileNumberController,
                  validator: AppValidator.validateMobileNumber,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // E-mail Address Field
                CustomTextFormField(
                  label: 'E-mail address',
                  hintText: 'enter your email address',
                  controller: _emailController,
                  validator: AppValidator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password Field
                CustomTextFormField(
                  label: 'Password',
                  hintText: 'enter your password',
                  controller: _passwordController,
                  validator: AppValidator.validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                CustomTextFormField(
                  label: 'Confirm Password',
                  hintText: 're-enter your password',
                  controller: _confirmPasswordController,
                  validator: (value) => AppValidator.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  isPassword: true,
                ),
                const SizedBox(height: 35),

                // Sign up Button
                ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF004182),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Already have an account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
