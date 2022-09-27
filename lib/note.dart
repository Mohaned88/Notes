import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> create_db() async {
  var dataBasePath = await getDatabasesPath();
  String path = join(dataBasePath, "notes.db");
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE notes (id INTEGER PRIMARY KEY,title TEXT,description TEXT,time TEXT)');
    },
  );
}

add_user(title,description,time) async{
  var db = await create_db();
  db.insert("notes", {
    "title": "$title",
    "description": "$description",
    "time": "$time",
  });
}

parse_single_note(description) async{
  var db = await create_db();
  var note = await db.query("notes",columns: ["id","title","description","time"],where: "description = ?",whereArgs: [description]);
  return note;
}
parse_all_notes() async{
  var db = await create_db();
  var notes = await db.query("notes",columns: ["id","title","description","time"]);
  return notes;
}


class NotePage extends StatelessWidget {
  TextEditingController txt_title_controller = TextEditingController();
  TextEditingController txt_Description_controller = TextEditingController();
  DateTime time = DateTime.now();
  TimeOfDay time2 = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(left: 20),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.amber,
          ),
        ),
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.amber,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_pin,
              color: Colors.amber,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.file_upload_outlined,
              color: Colors.amber,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: (){
                List descrip = txt_Description_controller.text.split("\n").sublist(1);
                if(txt_Description_controller.text.isNotEmpty){
                  add_user(txt_Description_controller.text.split("\n")[0],descrip.join("\n")," ${time.hour}:${time.minute}");/*${time.year}-${time.month}-${time.day} \n*/
                }
                else{
                  return null;
                }
              },
              icon: const Text(
                "Done",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
              padding: const EdgeInsets.all(0),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                expands: true,
                maxLines: null,
                controller: txt_Description_controller,
                cursorHeight: 20,
                decoration: const InputDecoration(
                  contentPadding:EdgeInsets.all(10),
                  isCollapsed: true,
                  hintText: "What's on your mind?...",
                  border: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
