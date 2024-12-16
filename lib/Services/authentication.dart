import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //for storing data in the cloud
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // for signUP

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String name}) async {
    String res = "Some error Occurred";
    try {
      //for registration
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //for adding user to our Cloud Firestore
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': credential.user!.uid,
        });
        res = "success";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String password,
    required String email,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the field";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  // change password
  // Future<String> changePassword({required String newPassword}) async {
  //   String res = "Some error occurred";
  //   try {
  //     User? user = _auth.currentUser;
  //
  //     // Check if the user is logged in
  //     if (user != null) {
  //       await user.updatePassword(newPassword); // Update the password
  //       res = "Password changed successfully!";
  //     } else {
  //       res = "User not logged in!";
  //     }
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }

  // Get user details (name)
  Future<String?> getUserName() async {
    String? name;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection("users").doc(user.uid).get();
        name = snapshot['name'];
      }
    } catch (e) {
      return null;
    }
    return name;
  }
}
