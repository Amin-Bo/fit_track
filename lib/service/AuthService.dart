import 'dart:convert';
import 'dart:io';
import 'dart:io' if (dart.library.html) 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_track/model/User.dart' as User;
import 'package:fit_track/provider/UserProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inscription
  Future<void> register(User.User user) async {
    try {
      // Créer un utilisateur avec Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          );

      // Ajouter les informations supplémentaires dans Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());
    } catch (e) {
      throw Exception("Erreur lors de l'inscription: $e");
    }
  }

  // Connexion
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        var userData =
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();
        // set to provider
        Provider.of<UserProvider>(context, listen: false).setUser(
          User.User(
            email: userCredential.user!.email ?? '',
            firstName: userData.data()!['firstName'] ?? '',
            lastName: userData.data()!['lastName'] ?? '',
            height: userData.data()!['height'] ?? 00,
            weight: userData.data()!['weight'] ?? 00,
          ),
        );
      }
    } catch (e) {
      throw Exception("Erreur lors de la connexion: $e");
    }
  }

  // Déconnexion
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Provider.of<UserProvider>(context, listen: false).clearUser();
  }

  // user upload his profile picture
  Future<void> uploadProfilePicture(
    BuildContext context,
    String filePath,
  ) async {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        String base64Image;

        // Handle mobile-specific file operations
        final bytes = File(filePath).readAsBytesSync();
        base64Image = base64Encode(bytes);

        // Update Firestore with the base64 image string
        await _firestore.collection('users').doc(user.uid).update({
          'profilePicture': base64Image,
        });

        // Update the provider with the new profile picture
        var userData = await _firestore.collection('users').doc(user.uid).get();
        Provider.of<UserProvider>(context, listen: false).setUser(
          User.User(
            email: user.email ?? '',
            firstName: userData.data()!['firstName'] ?? '',
            lastName: userData.data()!['lastName'] ?? '',
            height: userData.data()!['height'] ?? 00,
            weight: userData.data()!['weight'] ?? 00,
            profilePicture: base64Image,
          ),
        );
      }
    } catch (e) {
      throw Exception("Erreur lors de l'envoi de la photo de profil: $e");
    }
  }

  // Update user information
  Future<void> updateUserInfo(
    BuildContext context,
    User.User updatedUser,
  ) async {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        // Update Firestore with the new user information
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update(updatedUser.toMap());

        // Update the provider with the new user information
        Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);
      }
    } catch (e) {
      throw Exception(
        "Erreur lors de la mise à jour des informations utilisateur: $e",
      );
    }
  }
}
