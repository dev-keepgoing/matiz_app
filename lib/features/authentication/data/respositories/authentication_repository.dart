import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/authentication/data/models/user_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final String apiBaseUrl = "https://us-central1-matiz-app.cloudfunctions.net";

  AuthenticationRepository(
      {FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email', 'profile'],
              hostedDomain: '',
            );

  // Stream for user state changes
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // ✅ Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      throw Exception("ERROR AL CREAR LA CUENTA: ${e.toString()}");
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("LOGGEATE PRIMERO ANTES DE BORRAR LA CUENTA.");
      }

      await user.delete(); // Delete user from Firebase Authentication
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception("LOGGEATE PRIMERO ANTES DE BORRAR LA CUENTA.");
      } else {
        print("Error deleting account ${e.message}");
        throw Exception(
            "TUVMIOS PROBLEMA BORRATE LA CUENTA. TRATA DE NUEVO MÁS TARDE.");
      }
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("sign in ");
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      print("sign in credential ");

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      // Retrieve authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // ✅ Sign in to Firebase using the Google credential and return the UserCredential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print("error $e");
      throw Exception(
          "ENCONTRAMOS UN PROBLEMA EN NUESTRO LADO. TRATA DE NUEVO MÁS TARDE");
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _firebaseAuth.signInWithCredential(oauthCredential);
    } catch (e) {
      print("Apple Sign-In Error: $e");
      throw Exception("Failed to sign in with Apple");
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut(); // Ensure the user is signed out from Google
  }

  Future<ApiResponse<UserData>> getCurrentUserWithUserData() async {
    // Step 1: Get the current user's ID token
    final idToken = await getCurrentUserIdToken();
    if (idToken != null) {
      // Step 2: Fetch user data using the ID token
      return await fetchUserData(idToken);
    } else {
      throw Exception(
          'CREA O LOGGEATE A TU CUENTA PARA QUE VIVAS LA EXPERIENCIA DE matiz');
    }
  }

  Future<String?> getCurrentUserIdToken() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Reload the user to ensure the state is updated
      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser;
      final userToken = await refreshedUser?.getIdToken();

      printTokenInChunks("$userToken");

      // Get the ID token
      return userToken;
    }
    return null; // No user is logged in
  }

  Future<ApiResponse<UserData>> fetchUserData(String idToken) async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/getUser'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response into ApiResponse<UserData>
      final jsonResponse = json.decode(response.body);
      return ApiResponse<UserData>.fromJson(
        jsonResponse,
        (dataJson) => UserData.fromJson(dataJson),
      );
    } else {
      print("Could not login ${response.body}");
      throw Exception('Could not validate user, try again later');
    }
  }

  void printTokenInChunks(String token, {int chunkSize = 500}) {
    for (int i = 0; i < token.length; i += chunkSize) {
      print(token.substring(
          i, i + chunkSize > token.length ? token.length : i + chunkSize));
    }
  }

  Future<bool> validateEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
