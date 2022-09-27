import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled/note.dart';

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

Future<List<Map>> parse_all_notes() async {
  var db = await create_db();
  var notes =
      await db.query("notes", columns: ["id", "title", "description", "time"]);
  return notes;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    create_db();
    //parse_all_notes();
    var notes = parse_all_notes();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.amber,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.only(right: 20,top: 10),
            icon: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: parse_all_notes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Notes",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: ListView.separated(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: size.width * 0.2,
                            width: size.width,
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  "${snapshot.data![index]["title"]}",
                                ),
                                subtitle: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: Text(
                                        "${snapshot.data![index]["time"]}",
                                      ),
                                    ),
                                    Text(
                                      "${snapshot.data![index]["description"]}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                /*trailing: SizedBox(
                                  width: size.width * 0.2,
                                  child: Text(
                                    "${snapshot.data![index]["time"]}",
                                  ),
                                ),*/
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.grid_view_outlined,
                            color: Colors.amber,
                          ),
                        ),
                        Text("${snapshot.data!.length} Notes"),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotePage()));
                          },
                          icon: const Icon(
                            Icons.note_alt_outlined,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
