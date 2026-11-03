import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppAuthProvider extends ChangeNotifier {
  // اليوزر الحالي المسجّل دخوله — null لو مفيش حد logged in
  User? firebaseUser;

  // بيرجع true لو في يوزر logged in، false لو لأ
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  // بيتسمى لما يكمل تسجيل الدخول أو الإنشاء بنجاح
  // بيخزّن اليوزر في الـ state وبيخبر كل الـ Listeners
  void login(User newUser) {
    firebaseUser = newUser;
    notifyListeners();
  }

  // بيتسمى لما المستخدم يعمل logout
  // بيمسح اليوزر من الـ state وبيخبر كل الـ Listeners
  void logout() {
    firebaseUser = null;
    notifyListeners();
  }

  // ========== Firebase Auth Methods ==========

  // إنشاء حساب جديد — بترجع UserCredential لو نجح
  // أو بترمي FirebaseAuthException لو فشل
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  // تسجيل دخول — بترجع UserCredential لو نجح
  // أو بترمي FirebaseAuthException لو فشل
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  // تسجيل خروج من Firebase + مسح الـ state
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    logout();
  }
}

