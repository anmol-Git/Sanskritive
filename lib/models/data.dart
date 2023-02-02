import 'package:flutter/material.dart';
import 'dataModel.dart';
import 'firebaseModel.dart';

class Data with ChangeNotifier {
  List<DataModel> _usersData = [];
  List<String> _connectedUserIds = [];
  List<String> _receivedForMe = [];
  List<String> _sentByMe = [];
  final FirebaseModel fm = FirebaseModel();

  List<DataModel> get usersData {
    _usersData.sort((a, b) => a.distance.compareTo(b.distance));
    return [..._usersData];
  }

  void clearUsersData() {
    _usersData.clear();
  }

  void clearConnectedUsers() {
    _connectedUserIds.clear();
  }

  void addDataModel(DataModel dataModel) {
    _usersData.add(dataModel);
    notifyListeners();
  }

  void storeConnectedUserIds(List<String> connectedUserIds) {
    _connectedUserIds = connectedUserIds;
    notifyListeners();
  }

  void storeReceivedForMe(List<String> receivedForMe) {
    _receivedForMe = receivedForMe;
  }

  void storeSentByMe(List<String> sentByMe) {
    _sentByMe = sentByMe;
  }

  List<String> get connectedUserIds {
    return [..._connectedUserIds];
  }

  List<String> get sentByMe {
    return [..._sentByMe];
  }

  List<String> get receivedForMe {
    return [..._receivedForMe];
  }

  bool isConnected(String id) {
    if (_connectedUserIds.contains(id)) return true;
    return false;
  }

  void removeConnect(String id) {
    _connectedUserIds.remove(id);
    notifyListeners();
    fm.updateConnectedUserIds(_connectedUserIds, id);
  }

  void connect(String id) {
    _sentByMe.add(id);
    notifyListeners();
    fm.makeRequest(id, _sentByMe);
  }

  void accept(String id) {
    _receivedForMe.remove(id);
    _connectedUserIds.add(id);
    notifyListeners();
    fm.acceptRequest(id, _receivedForMe, _connectedUserIds);
  }

  bool sentByMeRequest(String id) {
    if (_sentByMe.contains(id)) return true;
    return false;
  }

  bool receivedForMeRequest(String id) {
    if (_receivedForMe.contains(id)) return true;
    return false;
  }

  int get count {
    return _receivedForMe.length + _sentByMe.length;
  }
}
