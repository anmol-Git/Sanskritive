import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';
import 'data.dart';
import 'dataModel.dart';
import 'location.dart';
import 'signInModel.dart';

class FirebaseModel {
  static const String projectName = 'Sanskritive';
  static const String messagingSenderId = '845002351889';
  static const String projectId = 'sanskritive';
  static const String apiKey = 'AIzaSyCVFB5zlUzLEvTod44vSRRe449R8OkyLrY';
  static const String appId = '1:845002351889:web:29e4bd8384f57d4e2ed8b0';
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static DocumentReference ref;

  Future<void> initializeFirebase() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).onError((error, st) {
        print('error is ' + error);
        return;
      });
    }
  }

  void initializeCollection(String userId) {
    ref = _db.collection('users').doc(userId);
  }

  Future<void> uploadUserData(User user) async {
    initializeCollection(user.uid);
    List<String> connectedUserIds = [];
    DocumentSnapshot ds = await ref.get();
    if (!ds.exists)
      await ref.set(
          {
            'name': user.displayName,
            'email': user.email,
            'photoUrl': user.photoURL,
            'userId': user.uid,
            'label': 'Beginner',
            'connectedUserIds': connectedUserIds,
            'bio': 'This is a bio',
            'sentByMe': [],
            'receivedForMe': [],
          },
          SetOptions(
            merge: true,
          ));
  }

  Future<void> updateUserLabel(String label) async {
    await ref.update({
      'label': label,
    });
  }

  Future<void> updateUserBio(String bio) async {
    await ref.update({
      'bio': bio,
    });
  }

  Future<void> updateConnectedUserIds(
      List<String> connectedUserIds, String userId) async {
    SignInModel signInModel = SignInModel();
    String currentUid = signInModel.getCurrentUser().uid;
    await ref.update({
      'connectedUserIds': connectedUserIds,
    });
    List<String> connectedUsers = [''];
    await _db.collection('users').doc(userId).get().then((documentSnapshot) {
      List<dynamic> _connectedUsers =
          documentSnapshot.data()['connectedUserIds'];
      connectedUsers = _connectedUsers.cast<String>();
    });
    connectedUsers.remove(currentUid);
    await _db.collection('users').doc(userId).update({
      'connectedUserIds': connectedUsers,
    });
  }

  Future<void> acceptRequest(String userId, List<String> receivedForMe,
      List<String> connectedUserIds) async {
    SignInModel signInModel = SignInModel();
    String currentUid = signInModel.getCurrentUser().uid;
    await ref.update({
      'connectedUserIds': connectedUserIds,
      'receivedForMe': receivedForMe,
    });
    List<String> sentByMe = [''];
    List<String> connectedUsers = [''];
    await _db.collection('users').doc(userId).get().then((documentSnapshot) {
      List<dynamic> _sentByMe = documentSnapshot.data()['sentByMe'];
      List<dynamic> _connectedUsers =
          documentSnapshot.data()['connectedUserIds'];
      connectedUsers = _connectedUsers.cast<String>();
      sentByMe = _sentByMe.cast<String>();
    });
    sentByMe.remove(currentUid);
    connectedUsers.add(currentUid);
    await _db.collection('users').doc(userId).update({
      'sentByMe': sentByMe,
      'connectedUserIds': connectedUsers,
    });
  }

  Future<void> makeRequest(String userId, List<String> sentByMe) async {
    SignInModel signInModel = SignInModel();
    String currentUid = signInModel.getCurrentUser().uid;
    await _db
        .collection('users')
        .doc(currentUid)
        .update({'sentByMe': sentByMe});
    List<String> received = [''];

    await _db.collection('users').doc(userId).get().then((documentSnapshot) {
      List<dynamic> _received = documentSnapshot.data()['receivedForMe'];
      received = _received.cast<String>();
    });
    received.add(currentUid);
    await _db
        .collection('users')
        .doc(userId)
        .update({'receivedForMe': received});
  }

  Future<DataModel> getUserDataFromUser(User user) async {
    initializeCollection(user.uid);
    DataModel data = DataModel(
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      userId: user.uid,
      label: 'Beginner',
    );
    return data;
  }

  Future<DataModel> getUserDataFromCloud(String userId) async {
    initializeCollection(userId);
    DataModel data = DataModel();
    await ref.get().then((documentSnapshot) {
      List<String> connectedUserIds = [];
      List<dynamic> connectedIds = documentSnapshot.data()['connectedUserIds'];
      connectedUserIds = connectedIds.cast<String>();
      List<String> receivedForMe = [];
      List<dynamic> _received = documentSnapshot.data()['receivedForMe'];
      receivedForMe = _received.cast<String>();
      List<String> sentByMe = [];
      List<dynamic> _sent = documentSnapshot.data()['sentByMe'];
      sentByMe = _sent.cast<String>();
      data = DataModel(
          name: documentSnapshot.data()['name'],
          email: documentSnapshot.data()['email'],
          photoUrl: documentSnapshot.data()['photoUrl'],
          userId: documentSnapshot.data()['userId'],
          label: documentSnapshot.data()['label'],
          connectedUserIds: connectedUserIds,
          bio: documentSnapshot.data()['bio'],
          receivedForMe: receivedForMe,
          sentByMe: sentByMe);
    });
    return data;
  }

  void updateLocation(LocationData locationData) async {
    await ref.update({
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
    });
  }

  Future<void> fetchConnectedUser(String uid, BuildContext context) async {
    initializeCollection(uid);
    Provider.of<Data>(context, listen: false).clearConnectedUsers();
    List<String> connectedUserIds = [];
    await ref.get().then((documentSnapshot) {
      List<dynamic> connectedIds = documentSnapshot.data()['connectedUserIds'];
      connectedUserIds = connectedIds.cast<String>();
    });
    Provider.of<Data>(context, listen: false)
        .storeConnectedUserIds(connectedUserIds);
  }

  Future<bool> fetchUsers(BuildContext context) async {
    Provider.of<Data>(context, listen: false).clearUsersData();
    SignInModel signInModel = SignInModel();
    String userId = signInModel.getCurrentUser().uid;
    fetchConnectedUser(userId, context);
    bool hasLocation = await getLocation();
    double userLat = 0;
    double userLong = 0;
    Location location = Location();
    LocationData locationData = await location.getLocation();
    userLat = locationData.latitude;
    userLong = locationData.longitude;
    CollectionReference reference = _db.collection('users');
    await reference.get().then((cs) {
      cs.docs.forEach((documentSnapshot) async {
        if (documentSnapshot.id != userId) {
          double distance = 0;
          if (hasLocation) {
            final double lat2 = documentSnapshot.data()['latitude'];
            final double long2 = documentSnapshot.data()['longitude'];
            distance = sqrt(pow(long2 - userLong, 2) + pow(lat2 - userLat, 2));
          }
          print(distance);
          print(documentSnapshot.data()['name']);
          DataModel dataModel = DataModel(
            name: documentSnapshot.data()['name'],
            email: documentSnapshot.data()['email'],
            photoUrl: documentSnapshot.data()['photoUrl'],
            userId: documentSnapshot.data()['userId'],
            label: documentSnapshot.data()['label'],
            bio: documentSnapshot.data()['bio'],
            distance: distance,
          );
          Provider.of<Data>(context, listen: false).addDataModel(dataModel);
        }
      });
    });
    return true;
  }
}
