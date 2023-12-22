import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_helloworld/firebase_options.dart';

void main() async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GDSCTrumanApp());
}

class GDSCTrumanApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GDSCHome()
    );
  }
}


class GDSCHome extends StatefulWidget {

  @override
  State<GDSCHome> createState() => _GDSCHomeState();
}

class _GDSCHomeState extends State<GDSCHome> {

  String trumanDoc = 'gdsc_data';
  String lehmanDoc = 'harvard';
  String docName = '';

  @override
  void initState() {
    super.initState();

    docName = trumanDoc;
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('GDSC Truman', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF500577),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.
          collection('gdsc_truman_docs').doc(docName).snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Text('My Data has an error');
          }

          if (snapshot.hasData) {

            var doc = snapshot.data!.data() as Map<String, dynamic>;
            var name = doc['name'];
            var institution = doc['institution'];
            var logo = doc['logo'];
            var numberOfStudents = doc['numberOfStudents'];
            
            return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(logo,
                  width: screenWidth / 2, height: screenWidth / 2,
                ),

                Text('Hello From $name $institution',

                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth * 0.05, 
                  color: Color(0xFF500577))
                ),
                Text('Number of Students: $numberOfStudents',

                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF500577))
                ),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () {

                    FirebaseFirestore.instance.
                    collection('gdsc_truman_docs').doc(docName).set(
                      {
                        'numberOfStudents': numberOfStudents + 1
                      }, SetOptions(merge: true));
                  }, 
                  child: Text('Add Student')
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    setState(() {
                      docName = docName == trumanDoc ? lehmanDoc : trumanDoc;
                    });
                  }, 
                  child: Text('Swap Documents')
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    FirebaseFirestore.instance.
                    collection('gdsc_truman_docs').doc('harvard').set(
                      {
                        'name': 'Harvard',
                        'institution': 'University',
                        'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Harvard_Crimson_logo.svg/1737px-Harvard_Crimson_logo.svg.png',
                        'numberOfStudents': numberOfStudents + 1
                      });
                  }, 
                  child: Text('Add New Document')
                ),
              ],
            )
          );
          }
          
          return SizedBox();
          
        },
      )
      
      
    );
  }
}
