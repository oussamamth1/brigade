import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String username;
  final String id;
  final String email;
  final Int phone;
  User(
      {required this.id,
      required this.email,
      required this.phone,
      required this.username});
  factory User.formDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        phone: doc['phone'],
        username: doc['username']);
  }

}
