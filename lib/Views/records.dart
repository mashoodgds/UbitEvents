import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubitevents/Utils/utils.dart';
import 'package:ubitevents/Views/homeScreen.dart';
import 'package:ubitevents/Views/search.dart';
import 'package:ubitevents/widgets/round_button.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {

  final _formKey = GlobalKey<FormState>();


  // Firestore instance  -- to get
  final attendees =
      FirebaseFirestore.instance.collection('attendees').snapshots();

  // Firestore instance  -- to update and delete
  CollectionReference ref = FirebaseFirestore.instance.collection('attendees');

  // Controllers
  final serailNoController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final signatureController = TextEditingController();

//// UPDATE RECORDS
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['name'].toString();
      serailNoController.text = documentSnapshot['serial_no'].toString();
      contactController.text = documentSnapshot['contact_no'].toString();
      signatureController.text = documentSnapshot['signature'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: serailNoController,
                  decoration: const InputDecoration(
                    labelText: 'Serial No.',
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact No.',
                  ),
                ),
                TextField(
                  controller: signatureController,
                  decoration: const InputDecoration(
                    labelText: 'Signature.',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final String name = nameController.text;
                      final String serial = serailNoController.text;
                      final String contact = contactController.text;
                      final String signature = signatureController.text;

                      await ref.doc('id').update({
                        "name": name,
                        "serial_no": serial,
                        "contact_no": contact,
                        "signature": signature
                      });
                      nameController.text = '';
                      serailNoController.text = '';
                      contactController.text = '';
                      signatureController.text = '';
                      Navigator.of(context).pop();
                    })
              ],
            ),
          );
        });
  }

  ////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Records' ,style: TextStyle(fontSize: 22 , fontWeight: FontWeight.w500),),
        
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
                                          icon: const Icon(Icons.more_vert , color: Color.fromARGB(255, 255, 197, 36),),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                // ignore: prefer_const_constructors
                                                builder: (BuildContext ctx) {
                                                  return Form(
                                                   key : _formKey,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 20,
                                                          left: 20,
                                                          right: 20,
                                                          bottom: MediaQuery.of(ctx)
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
                                                            TextFormField(
                                                              controller:serailNoController,
                                                              keyboardType: TextInputType.number,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Serial No.',
                                                              ),
                                                               validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return ('Enter Serial No');
                                                                }
                                                              },
                                                            ),
                                                            TextFormField(
                                                              controller:nameController, 
                                                              keyboardType: TextInputType.text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      labelText:
                                                                          'Name'),
                                                             validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return ('Enter Name');
                                                                }
                                                              },
                                                            ),
                                                            TextFormField(
                                                              controller:contactController,
                                                              keyboardType: TextInputType.number,
                                                              
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Contact No.',
                                                              ),
                                                               validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return ('Enter Contact No.');
                                                                }
                                                              },
                                                            ),
                                                            TextFormField(
                                                              controller:signatureController,
                                                              keyboardType: TextInputType.text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Signature.',
                                                              ),
                                                               validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return ('Enter signature');
                                                                }
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children:  [
                                                                IconButton(
                                                                    onPressed: () {
                                                                      if (_formKey.currentState!.validate()) {
                                                                        ref.doc(snapshot
                                                                              .data!.docs[index]['id'])
                                                                          .set({
                                                                        'name': nameController.text.toString(),
                                                                        'serial_no':serailNoController.text.toString(),
                                                                        'contact_no':contactController.text.toString(),
                                                                        'signature':signatureController.text.toString()
                                                                      }).then((value) {
                                                                        Utils().toastMessage(
                                                                            'Record Updated');
                                                                      });
                                                                      }
                                                                      Navigator.pop(context); 
                                                                      
                                                                  
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .edit , size: 40, color:  Colors.green,)),
                                                                IconButton(
                                                                    onPressed: () {
                                    
                                                                      // Delete
                                                                
                                                                      ref.doc(snapshot.data!.docs[index]['id'])
                                                                          .delete()
                                                                          .then(
                                                                              (value) {
                                                                        Utils().toastMessage(
                                                                            'Record Deleted');
                                                                      });
                                                                      Navigator.pop(context);
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .delete , size: 40, color: Colors.red,))
                                                              ],
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
