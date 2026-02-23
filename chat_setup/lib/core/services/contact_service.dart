import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> syncContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);

      List<String> phoneNumbers = [];
      for (var contact in contacts) {
        for (var phone in contact.phones) {
          String sanitized = _sanitizePhoneNumber(phone.number);
          if (sanitized.isNotEmpty) {
            phoneNumbers.add(sanitized);
          }
        }
      }

      if (phoneNumbers.isEmpty) return [];

      // Firestore whereIn has a limit of 30 items. We need to chunk.
      List<UserModel> matchedUsers = [];
      for (var i = 0; i < phoneNumbers.length; i += 30) {
        var end = (i + 30 < phoneNumbers.length) ? i + 30 : phoneNumbers.length;
        var chunk = phoneNumbers.sublist(i, end);

        var querySnapshot = await _firestore
            .collection('users')
            .where('phone', whereIn: chunk)
            .get();

        for (var doc in querySnapshot.docs) {
          matchedUsers.add(UserModel.fromMap(doc.id, doc.data()));
        }
      }

      return matchedUsers;
    }
    return [];
  }

  String _sanitizePhoneNumber(String phone) {
    // Remove non-digit characters except maybe +
    String sanitized = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return sanitized;
  }
}
