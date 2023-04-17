import 'package:flutter/material.dart';
import 'package:notable/appstyle.dart';
import 'package:intl/intl.dart';
import 'package:notable/services/database_service.dart';

class NoteScreen extends StatefulWidget {
  //NoteScreen route name
  static const routeName = '/write-read-screen';

  //NoteScreen Constructor
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController titleController;
  late TextEditingController noteController;
  String? docId;
  late String time;
  late Color primarycolor;
  bool _loadedInitData = false;
  bottomSheetColor(Color bottomSheetColor) {
    return setState(() {
      primarycolor = bottomSheetColor;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      late final routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      titleController = routeArgs['titleController'];
      noteController = routeArgs['noteController'];
      docId = routeArgs['docId'];
      time = routeArgs['time'];
      primarycolor = Color(routeArgs['color']);
      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  //Automatically Save Note
  void autoSave() async {
    if (docId == null) {
      if (titleController.text.isEmpty && noteController.text.isEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text(
        //     'Empty card discarded',
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        //   backgroundColor: Colors.white,
        //   behavior: SnackBarBehavior.floating,
        // ));
      } else {
        await Db().createNote(
          titleController.text,
          noteController.text,
          primarycolor.value,
          DateFormat.yMd().add_jm().format(DateTime.now()),
        );
      }
    } else {
      await Db().updateNote(
        docId!,
        titleController.text,
        noteController.text,
        primarycolor.value,
        DateFormat.yMd().add_jm().format(DateTime.now()),
      );
    }
  }

  //Calls functions when disposing widget from tree
  @override
  void dispose() {
    autoSave();
    super.dispose();
  }

  // final GlobalKey<ScaffoldState> _globalkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: primarycolor,

      //appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          CustomIconButton(onPressed: () {}, icon: Icons.pin_drop_outlined),
          CustomIconButton(
              onPressed: () {}, icon: Icons.notification_add_outlined),
          CustomIconButton(
              onPressed: () {}, icon: Icons.file_download_outlined),
        ],
      ),

      //TextFields for Input Begins
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: Theme.of(context).textTheme.titleLarge,
                ),
                maxLines: 1,
              ),
              // const SizedBox(
              //   height: 2,
              // ),
              TextField(
                controller: noteController,
                keyboardType: TextInputType.multiline,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: 'Note',
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                minLines: 23,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
      //TextFields for Input Ends

      //BottomBar Begins
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconButton(onPressed: () {}, icon: Icons.add_box_outlined),
              CustomIconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      constraints: const BoxConstraints(maxHeight: 260),
                      context: context,
                      builder: (ctx) {
                        return BottomSheet(
                          primarycolor: primarycolor,
                          bottomSheetColor: bottomSheetColor,
                        );
                      },
                    );
                  },
                  icon: Icons.color_lens_outlined),
            ],
          ),
          Text(
            'Edited $time',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          CustomIconButton(onPressed: () {}, icon: Icons.more_vert_outlined),
        ],
      ),
      //BottomBar Ends
    );
  }
}

//BOTTOMSHEET WIDGET Starts
// ignore: must_be_immutable
class BottomSheet extends StatefulWidget {
  BottomSheet({
    super.key,
    required this.primarycolor,
    required this.bottomSheetColor,
  });

  final Color primarycolor;
  late Function(Color) bottomSheetColor;

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  late Color _primarycolor;
  @override
  void initState() {
    _primarycolor = widget.primarycolor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _primarycolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Color',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < 6; i++)
                  InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      setState(() {
                        _primarycolor = Appstyle.myColors[i]!;
                      });
                      widget.bottomSheetColor(_primarycolor);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Appstyle.myColors[i],
                              border: Border.all(
                                color: _primarycolor == Appstyle.myColors[i]
                                    ? Colors.blue
                                    : Colors.grey,
                                width: _primarycolor == Appstyle.myColors[i]
                                    ? 1.5
                                    : 1.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6.5,
                            right: 7,
                            child: Icon(
                              Icons.check,
                              size: 35,
                              color: _primarycolor == Appstyle.myColors[i]
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          // const SizedBox(
          //   height: 25,
          // ),
        ],
      ),
    );
  }
}
//BOTTOMSHEET WIDGET ends

//Reuseable CustomIconButton
class CustomIconButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
