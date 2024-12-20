import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class ProfileScreen extends StatelessWidget {
  final dynamic userData;

  ProfileScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    // Initialize Stripe
    Stripe.publishableKey = "your-publishable-key";

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future<void> addCard() async {
      try {
        final billingDetails = BillingDetails(
          email: userData['email'],
          phone: userData['phoneNumber'],
        );

        final paymentMethod = await Stripe.instance.createPaymentMethod(
          PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
          ),
        );

        if (paymentMethod != null) {
          await firestore
              .collection('users')
              .doc(userData['uid'])
              .collection('cards')
              .add({
            'last4': paymentMethod.card!.last4,
            'exp_month': paymentMethod.card!.expMonth,
            'exp_year': paymentMethod.card!.expYear,
            'brand': paymentMethod.card!.brand,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData['userAvatar']),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData['fullName'] ?? 'No name',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData['email'] ?? 'No email',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData['phoneNumber'] ?? 'No phone number',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Update Personal Information Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Update Information',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'License Plate Number',
                          prefixIcon: Icon(Icons.directions_car),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle the information update here
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Card Management Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Manage Cards',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: addCard,
                        child: const Text('Add Card'),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot>(
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
                            shrinkWrap: true,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
