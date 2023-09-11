import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubitevents/Utils/utils.dart';
import 'package:ubitevents/Views/homeScreen.dart';

class Records extends StatefulWidget {
  const Records({
    super.key,
    required this.role,
  });

  final String role;
  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final _formKey = GlobalKey<FormState>();

  // Firestore instance  -- to get

  // Firestore instance  -- to update and delete
  CollectionReference ref = FirebaseFirestore.instance.collection('attendees');
  final attendees =
      FirebaseFirestore.instance.collection('attendees').snapshots();
  // Controllers
  String serailNoController = "";
  String nameController = "";
  String contactController = "";
  String signatureController = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Records',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          // Fetching Records

          StreamBuilder<QuerySnapshot>(
              stream: attendees,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: (Text("Error loading list")),
                  );
                } else {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * .04,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .002),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                        snapshot.data!.docs[index]['name']),
                                    subtitle: Text(snapshot.data!.docs[index]
                                        ['serial_no']),
                                    //   //Update
                                    trailing: Visibility(
                                      child: IconButton(
                                          icon: const Icon(
                                            Icons.more_vert,
                                            color: Color.fromARGB(
                                                255, 255, 197, 36),
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                // ignore: prefer_const_constructors
                                                builder: (BuildContext ctx) {
                                                  return Form(
                                                    key: _formKey,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 20,
                                                          left: 20,
                                                          right: 20,
                                                          bottom: MediaQuery.of(
                                                                      ctx)
                                                                  .viewInsets
                                                                  .bottom +
                                                              20),
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            //Serial No.
                                                            TextFormField(
                                                              initialValue: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['serial_no'],
                                                              onChanged:
                                                                  (value) {
                                                                serailNoController =
                                                                    value
                                                                        .toString();
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Serial No.',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return ('Enter Serial No');
                                                                }
                                                              },
                                                            ),

                                                            //Name
                                                            TextFormField(
                                                              initialValue: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['name'],
                                                              onChanged:
                                                                  (value) {
                                                                nameController =
                                                                    value
                                                                        .toString();
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      labelText:
                                                                          'Name'),
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return ('Enter Name');
                                                                }
                                                              },
                                                            ),
                                                            //Contact No

                                                            TextFormField(
                                                              initialValue: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'contact_no'],
                                                              onChanged:
                                                                  (value) {
                                                                contactController =
                                                                    value
                                                                        .toString();
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Contact No.',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return ('Enter Contact No.');
                                                                }
                                                              },
                                                            ),
                                                            //Signature No
                                                            TextFormField(
                                                              initialValue: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['signature'],
                                                              onChanged:
                                                                  (value) {
                                                                serailNoController =
                                                                    value
                                                                        .toString();
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Signature.',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return ('Enter signature');
                                                                }
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Visibility(
                                                              visible:
                                                                  widget.role ==
                                                                      "admin",
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (true) {
                                                                          await ref
                                                                              .doc(snapshot.data!.docs[index]['id'])
                                                                              .delete();
                                                                          String
                                                                              id =
                                                                              DateTime.now().millisecondsSinceEpoch.toString();

                                                                          await ref
                                                                              .doc(id)
                                                                              .set({
                                                                            'id':
                                                                                id,
                                                                            'name':
                                                                                nameController,
                                                                            'serial_no':
                                                                                serailNoController,
                                                                            'contact_no':
                                                                                contactController,
                                                                            'signature':
                                                                                signatureController,
                                                                          });
                                                                        }

                                                                        Utils().toastMessage(
                                                                            'Record Updated');
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        size:
                                                                            40,
                                                                        color: Colors
                                                                            .green,
                                                                      )),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        // Delete

                                                                        ref
                                                                            .doc(snapshot.data!.docs[index]['id'])
                                                                            .delete()
                                                                            .then((value) {
                                                                          Utils()
                                                                              .toastMessage('Record Deleted');
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        size:
                                                                            40,
                                                                        color: Colors
                                                                            .red,
                                                                      ))
                                                                ],
                                                              ),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                });
                                          }),
                                    ),
                                  ),
                                ));
                          }));
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // IconButton(onPressed: (){
              //   Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (_) => const Search()));
              // }, icon: Icon(Icons.search)),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * .08,
                    right: MediaQuery.of(context).size.width * .09),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddUserScreen()));
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
