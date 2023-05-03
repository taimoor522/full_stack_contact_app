import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Contact App',
      home: ContactScreen(),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<http.Response?>? getContacts() async {
    try {
      return await http.get(Uri.parse('https://10.0.2.2:8888'));
    } catch (e) {
      debugPrint('LOG : Exception $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact App'),
      ),
      body: FutureBuilder<http.Response?>(
          future: getContacts(),
          builder: (context, snapshot) {
            final response = snapshot.data;
            if (response == null) {
              return const Text('LOG Response is Null');
            }
            if (response.statusCode != 200) {
              return Text('LOG Response.statuscode == ${response.statusCode}');
            }
            final List<Contact> contacts = (jsonDecode(response.body) as List)
                .map((jsonContact) => Contact.fromJson(jsonContact))
                .toList();
            return ListView.builder(
              itemBuilder: (_, index) {
                return Text(contacts[index].name);
              },
              itemCount: contacts.length,
            );
          }),
    );
  }
}

class Contact {
  String name;
  String phone;
  String email;
  Contact({
    required this.name,
    required this.phone,
    required this.email,
  });

  Contact copyWith({
    String? name,
    String? phone,
    String? email,
  }) {
    return Contact(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Contact(name: $name, phone: $phone, email: $email)';

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;

    return other.name == name && other.phone == phone && other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ phone.hashCode ^ email.hashCode;
}
