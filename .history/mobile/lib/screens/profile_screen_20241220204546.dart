import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ProfileScreen extends StatelessWidget {
  final dynamic userData;

  ProfileScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    // Initialize Stripe
    StripePayment.setOptions(StripeOptions(
      publishableKey: "your-publishable-key",
      androidPayMode: 'test',
    ));

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future<void> addCard() async {
      try {
        var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest(),
        );

        if (paymentMethod != null) {
          final card = paymentMethod.card!;
          await firestore
              .collection('users')
              .doc(userData['uid'])
              .collection('cards')
              .add({
            'last4': card.last4,
            'exp_month': card.expMonth,
            'exp_year': card.expYear,
            'brand': card.brand,
            'created': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Card added successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding card: $e')),
        );
      }
    }

    Future<void> removeCard(String cardId) async {
      try {
        await firestore
            .collection('users')
            .doc(userData['uid'])
            .collection('cards')
            .doc(cardId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Card removed successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing card: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Manage Cards',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: addCard,
              child: const Text('Add Card'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('users')
                    .doc(userData['uid'])
                    .collection('cards')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final cards = snapshot.data?.docs ?? [];

                  if (cards.isEmpty) {
                    return const Center(child: Text('No cards found'));
                  }

                  return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final cardData = cards[index];
                      final cardInfo = cardData.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text('**** **** **** ${cardInfo['last4']}'),
                          subtitle: Text(
                              'Expires: ${cardInfo['exp_month']}/${cardInfo['exp_year']}'),
                          leading: Icon(Icons.credit_card, color: Colors.blue),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeCard(cardData.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
