import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../util/formatage_date.dart';
import '../models/membre.dart';
import '../services_firebase/service_firestore.dart';
import 'avatar.dart';


class HeaderMembre extends StatelessWidget {
  const HeaderMembre({
    super.key,
    required this.date,
    required this.memberId,
  });

  final int date;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(memberId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data!.data() != null) {
          final data = snapshot.data!;
          final Membre member = Membre(
            id: memberId,
            reference: data.reference,
            map: data.data() as Map<String, dynamic>,
          );

          return Row(
            children: [
              Avatar(radius: 20, imageUrl: member.profilePicture),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  member.fullname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                FormatageDate().formatted(date),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}