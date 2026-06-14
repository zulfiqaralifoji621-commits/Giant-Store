import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<AppUser?> getCurrentAppUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      final appUser = AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'Shopper',
        isAdmin: false,
      );
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
      return appUser;
    }
    return AppUser.fromMap(user.uid, doc.data()!);
  }

  Stream<AppUser?> watchCurrentAppUser() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return AppUser.fromMap(user.uid, doc.data()!);
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) return;

    await user.updateDisplayName(displayName);
    await _firestore.collection('users').doc(user.uid).set({
      'email': email,
      'displayName': displayName,
      'isAdmin': false,
    });
  }

  Future<void> signOut() => _auth.signOut();
}
