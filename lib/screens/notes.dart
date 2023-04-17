import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notable/appstyle.dart';
import 'package:notable/services/auth_service.dart';
import 'package:notable/widgets/notetile.dart';
import 'package:notable/services/database_service.dart';
import 'package:notable/screens/note_screen.dart';
import 'package:notable/widgets/mydrawer.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});
  //home route name
  static const routeName = '/notes';

  @override
  State<Notes> createState() => NotesState();
}

class NotesState extends State<Notes> {
  //define textEditingControllers
  late final TextEditingController titleController;
  late final TextEditingController noteController;
  // late String userId;
  // bool _loadedInitData = false;

  @override
  void initState() {
    titleController = TextEditingController();
    noteController = TextEditingController();
    Db();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (!_loadedInitData) {
  //     late final routeArgs =
  //         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  //     userId = routeArgs["userId"];
  //     _loadedInitData = true;
  //   }
  //   super.didChangeDependencies();
  // }

  //Creating a new note
  void onAdd(
    String title,
    String note,
    String? docId,
    String time,
    int color,
  ) {
    titleController.text = title;
    noteController.text = note;
    Navigator.pushNamed(context, NoteScreen.routeName, arguments: {
      'titleController': titleController,
      'noteController': noteController,
      'docId': docId,
      'time': time,
      'color': color,
    });
  }

  // void emptyNoteDeleted(BuildContext context) {
  //   if (titleController.text.isEmpty && noteController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text(
  //         'Empty card discarded',
  //         style: TextStyle(color: Colors.black),
  //       ),
  //       padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  //       backgroundColor: Colors.white,
  //       behavior: SnackBarBehavior.floating,
  //     ));
  //   }
  // }

  //when tapping on existing note
  void onTap(DocumentSnapshot documentSnapshot) {
    titleController.text = documentSnapshot['title'];
    noteController.text = documentSnapshot['note'];
    Navigator.pushNamed(context, NoteScreen.routeName, arguments: {
      'titleController': titleController,
      'noteController': noteController,
      'docId': documentSnapshot.id,
      'time': documentSnapshot['time'],
      'color': documentSnapshot['colorid'],
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  //hashset initialization
  HashSet<int> selectedItem = HashSet();

  //Multi-Selection initialized
  bool isMultiSelectionEnabled = false;

  //Multi-Selection Disabled
  void disableMultiSelection() {
    selectedItem.clear();
    isMultiSelectionEnabled = false;
    setState(() {});
  }

  //Multi-Selection method
  void doMultiSelection(int index) {
    if (selectedItem.contains(index)) {
      selectedItem.remove(index);
    } else {
      selectedItem.add(index);
    }
    setState(() {});
  }

  //Get Selected Item count when Multi-Selection enabled
  String getSelectedItemCount() {
    return selectedItem.isNotEmpty ? '${selectedItem.length}' : '0';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Db().users.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        // final List<Map<String, dynamic>> docsList = streamSnapshot.data!.docs
        //     .map((DocumentSnapshot document) {
        //       Map<String, dynamic> data =
        //           document.data()! as Map<String, dynamic>;
        //       return data;
        //     })
        //     .cast<Map<String, dynamic>>()
        //     .toList();
        if (streamSnapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              drawer: const MyDrawer(),

              //notes
              body: CustomScrollView(
                slivers: [
                  isMultiSelectionEnabled
                      ? SliverAppBar(
                          pinned: true,
                          backgroundColor: Colors.grey.shade900,
                          elevation: 0,
                          leading: IconButton(
                            onPressed: disableMultiSelection,
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                          ),
                          title: SizedBox(
                              width: 200,
                              child: Text(
                                getSelectedItemCount(),
                                style: const TextStyle(color: Colors.white70),
                              )),
                          actions: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notification_add_sharp,
                                  color: Colors.white70),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.palette,
                                  color: Colors.white70),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: () async {
                                for (int index in selectedItem) {
                                  Db()
                                      .deleteNote(
                                          streamSnapshot.data!.docs[index].id)
                                      .asStream();
                                }
                                disableMultiSelection();
                              },
                              icon: const Icon(Icons.delete,
                                  color: Colors.white70),
                            ),
                          ],
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                          sliver: SliverAppBar(
                            titleSpacing: 0.0,
                            centerTitle: false,
                            primary: false,
                            toolbarHeight: 50,
                            backgroundColor: Colors.black87,
                            elevation: 0,
                            floating: true,
                            snap: true,
                            shape: ShapeBorder.lerp(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                1.0),
                            title: TextButton(
                              onPressed: () {
                                showSearch(
                                    context: context, delegate: CustomSearch());
                              },
                              child: const Text(
                                'Search your notes',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  AuthService().signOut();
                                },
                                icon: const Icon(Icons.logout,
                                    color: Colors.white70),
                              ),
                              // ignore: prefer_const_constructors
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: const CircleAvatar(
                                  radius: 17,
                                  backgroundImage:
                                      AssetImage('lib/images/girla.jpeg'),
                                ),
                              ),
                            ],
                          ),
                        ),

                  //listview
                  streamSnapshot.data!.docs.isEmpty
                      ? SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 250),
                          sliver: SliverToBoxAdapter(
                            child: Center(
                              child: Text(
                                'Your Notes appear here!',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        )
                      : SliverReorderableList(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final QueryDocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            return Notetile(
                              key: ValueKey(documentSnapshot.id),
                              documentSnapshot: documentSnapshot,
                              onTap: () => isMultiSelectionEnabled
                                  ? doMultiSelection(index)
                                  : onTap(documentSnapshot),
                              onLongPress: () {
                                setState(() {
                                  isMultiSelectionEnabled = true;
                                  doMultiSelection(index);
                                });
                              },
                              decoration: isMultiSelectionEnabled
                                  ? selectedItem.contains(index)
                                      ? BoxDecoration(
                                          color: Color(
                                              documentSnapshot['colorid']),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Theme.of(context).hintColor,
                                            style: BorderStyle.solid,
                                            width: 2.7,
                                          ),
                                        )
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Color(
                                              documentSnapshot['colorid']),
                                        )
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(documentSnapshot['colorid']),
                                    ),
                            );
                          },
                          onReorder: (int oldIndex, int newIndex) {},
                          // addAutomaticKeepAlives: false,
                          // addRepaintBoundaries: false,
                          // childCount: streamSnapshot.data!.docs.length,
                        ),
                ],
              ),

              //add new note
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  onAdd(
                    '',
                    '',
                    null,
                    DateFormat.yMd().add_jm().format(DateTime.now()),
                    Appstyle.myColors[0]!.value,
                  );
                },
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CustomSearch extends SearchDelegate {
  // List<Map<String, dynamic>> list;

  // CustomSearch(this.list);
  final CollectionReference _firestore = Db().users;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.snapshots().asBroadcastStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No data!'),
          );
        }
        return ListView(children: [
          ...snapshot.data!.docs
              .where((element) => element['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .map((data) {
            final String title = data['title'];
            final String note = data.get('note');

            return ListTile(
              title: Text(title),
              subtitle: Text(note),
            );
          })
        ]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search anything here'),
    );
  }
}

// List matchQuery = [];
//     for (var i in searchTerms) {
//       if (i.containsValue(query.toLowerCase())) {
//         matchQuery.add(i);
//       }
//     }
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );

// List results = searchTerms
//         .where((note) => note.containsValue(query.toLowerCase()))
//         .toList();
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         String result = results.toString();
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );

// return StreamBuilder(
//       stream: notes,
//       builder: (context, AsyncSnapshot<dynamic> snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: Text('No data!'),
//           );
//         }
//         return ListView(
//           children: snapshot.data,
//         );
//       },
//     );

// List<Map<String, dynamic>> results = [];
//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         List<Map<String, dynamic>> results = list
//             .where((note) => note.containsValue(query.toLowerCase()))
//             .toList();
//         String result1 = results.toString();
//         String result2 = results.toString();
//         return ListTile(
//           title: Text(result1),
//           subtitle: Text(result2),
//         );
//       },
//     );