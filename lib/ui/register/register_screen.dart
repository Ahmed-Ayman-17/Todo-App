import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/app_auth_provider.dart';
import 'package:todo_app/ui/common/custom_text_form_field.dart';
import 'package:todo_app/ui/login/login_screen.dart';
import 'package:todo_app/ui/utils/dialog_utils.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    // تحقق من الـ Form أولاً
    if (_formKey.currentState?.validate() != true) return;

    // اجيب الـ provider بدون listen لأن في دالة وليس في الـ build
    final authProvider =
        Provider.of<AppAuthProvider>(context, listen: false);

    // اعرض Loading Dialog أثناء انتظار Firebase
    DialogUtils.showLoadingDialog(context);

    try {
      // الكلام مع Firebase عبر الـ Provider مش مباشرةً
      UserCredential credential =
          await authProvider.createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // حدّث الاسم الكامل في Firebase
      await credential.user?.updateDisplayName(
        _fullNameController.text.trim(),
      );

      // أخبر الـ Provider بالـ User الجديد
      if (credential.user != null) {
        authProvider.login(credential.user!);
      }

      if (!mounted) return;
      // أخفِ الـ Loading
      DialogUtils.hideDialog(context);

      // اعرض رسالة نجاح مع زرار للانتقال للـ Login
      DialogUtils.showMessage(
        context,
        message: 'Account created successfully! Please log in.',
        posBottomTitle: 'Login',
        posBottomAction: () {
          Navigator.of(context, rootNavigator: true).pop(); // أغلق الـ Dialog
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      // أخفِ الـ Loading أولاً
      DialogUtils.hideDialog(context);

      // اعرض رسالة الخطأ المناسبة
      DialogUtils.showMessage(
        context,
        message: _getRegisterErrorMessage(e.code),
        posBottomTitle: 'OK',
        posBottomAction: () =>
            Navigator.of(context, rootNavigator: true).pop(),
      );
    }
  }

  // ترجمة أكواد أخطاء Register لرسائل مفهومة
  String _getRegisterErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/Password sign-up is not enabled. Contact support.';
      default:
        return 'Registration failed. Please try again.\n(Error: $code)';
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),

                // Already have an account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        // pushReplacementNamed علشان منرجعش للـ Register بزرار Back
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
                          decorationColor: Colors.white,
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
