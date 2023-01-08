import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// time ago
import 'package:timeago/timeago.dart' as timeago;

class HistoryDialog extends StatelessWidget {
  HistoryDialog({super.key, required this.userId});
  String userId;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              const Text(
                'GOING FROM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              // pickup location
              const Text(
                'Dilibazar, Nepal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Icon(
                Icons.arrow_downward,
                size: 15,
                color: Colors.green,
              ),
              // text
              const Text(
                'GOING TO',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              // pickup location
              const Text(
                'Kalopul, Kathmandu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  Text("Station History",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .ref()
                        .child(
                            'user/${userId}/arrived')
                        .onValue,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(
                            radius: 20,
                            animating: true,
                          ),
                        );
                      }

                      if (snapshot.hasData &&
                          snapshot.data!.snapshot.value != null) {
                        Map<dynamic, dynamic> rating = snapshot
                            .data!.snapshot.value as Map<dynamic, dynamic>;

                        // Iterate through the ride history objects and build a list
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: rating.length,
                            itemBuilder: (context, index) {
                              var review = rating.values.elementAt(index);
                              return ListTile(
                                leading: const Icon(Icons.bus_alert_outlined),
                                title: Text(review['arrivedLocation']),
                                subtitle: Text(timeago.format(
                                    DateTime.parse(review['arrivedTime']))),
                                trailing: const Icon(Icons.location_on),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('No Review Found!!!'),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
