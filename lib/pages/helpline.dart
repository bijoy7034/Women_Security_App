import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  // Function to launch the dialer
  Future<void> dialNumber(
      {required String phoneNumber, required BuildContext context}) async {
    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( "Unable to call $phoneNumber");
    }

    return;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Helplines',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            // Wrap each container with GestureDetector
            GestureDetector(
              onTap: () {
                dialNumber( phoneNumber: '100', context: context); // Police
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                          child: Text(
                            'Police',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                dialNumber( phoneNumber: '1098', context: context);// Child Helpline
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                          child: Text(
                            'Child Helpline',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                dialNumber( phoneNumber: '1091', context: context); // Women Helpline
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                          child: Text(
                            'Women Helpline',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                dialNumber( phoneNumber: '101', context: context); // Fire Force
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                          child: Text(
                            'Fire Force',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
