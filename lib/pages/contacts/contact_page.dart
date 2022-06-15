import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'form.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    //The entry point for accessing a [FirebaseFirestore].
    FirebaseFirestore firebase = FirebaseFirestore.instance;

    //get collection from firebase, collection is table in mysql
    CollectionReference users = firebase.collection('users');

    return Scaffold(
      appBar: AppBar(
          //make appbar with icon
          title: Center(
        child: Text("CONTACT APP"),
      )),
      body: FutureBuilder<QuerySnapshot>(
        //data to be retrieved in the future
        future: users.get(),
        builder: (_, snapshot) {
          //show if there is data
          if (snapshot.hasData) {
            // we take the document and pass it to a variable
            var alldata = snapshot.data!.docs;

            //if there is data, make list
            return alldata.length != 0
                ? ListView.builder(

                    // displayed as much as the variable data alldata
                    itemCount: alldata.length,

                    //make custom item with list tile.
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          //get first character of name
                          child: Text(alldata[index]['name'][0]),
                        ),
                        title: Text(alldata[index]['name'], style: TextStyle(fontSize: 20)),
                        subtitle: Text(alldata[index]['phoneNumber'], style: TextStyle(fontSize: 16)),
                        trailing: IconButton(
                            onPressed: () async {
                              var hasilDariFormx = await Navigator.push(
                                context,
                                //pass data to edit form
                                MaterialPageRoute(
                                    builder: (context) => FormPage(
                                          id: snapshot.data!.docs[index].id,
                                        )),
                              );
                              if (hasilDariFormx == true) {
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.arrow_forward_rounded)),
                      );
                    })
                : Center(
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
          } else {
            return Center(child: Text("Loading...."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var hasilDariForm = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
          if (hasilDariForm == true) {
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
