import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setupProfile({
    required String uid,
    required String name,
    required int dailyTarget,
    required String timezone,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'dailyTarget': dailyTarget,
      'timezone': timezone,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
