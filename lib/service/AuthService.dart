import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_track/model/User.dart' as User;

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
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception("Erreur lors de la connexion: $e");
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }
}
