import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scabble/input_field.dart';
import "package:shared_preferences/shared_preferences.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ScrabblePlayer> players = [];

  final Map defaultPoints = {
    'a': 1,
    'b': 3,
    'c': 3,
    'd': 2,
    'e': 1,
    'f': 4,
    'g': 2,
    'h': 4,
    'i': 1,
    'j': 8,
    'k': 5,
    'l': 1,
    'm': 3,
    'n': 1,
    'o': 1,
    'p': 3,
    'q': 10,
    'r': 1,
    's': 1,
    't': 1,
    'u': 1,
    'v': 4,
    'w': 4,
    'x': 8,
    'y': 4,
    'z': 10,
  };

  late Map pointMap;
  late SharedPreferences saveData;

  Future<String> setup() async {
    saveData = await SharedPreferences.getInstance();
    final data = saveData.getString("points");
    if (data != null) {
      pointMap = jsonDecode(data);
    } else {
      pointMap = Map.from(defaultPoints);
    }

    return "done";
  }

  void editDialog(op, player) {
    TextEditingController word = TextEditingController();
    int multiplier = 1;
    int lastLength = 0;
    int points = 0;
    List<Character> letters = [];
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(builder: (context, stateSetter) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Inputfield(
                            controller: word,
                            hintText: "Word",
                            onChanged: (newWord) {
                              if (newWord.length > lastLength) {
                                letters.add(Character(
                                  char: newWord.split("").last,
                                ));
                              } else if (newWord.length < lastLength) {
                                letters.removeLast();
                              }
                              stateSetter(() {});
                            }),
                      ),
                      Expanded(
                        child: DropdownButton(
                          value: multiplier,
                          items: ["1x", "2x", "3x"]
                              .map((e) => DropdownMenuItem(
                                    value: int.parse(e.replaceAll("x", "")),
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (newChoice) => stateSetter(
                            () {
                              multiplier = newChoice ?? 1;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                      children: letters
                          .map(
                            (letter) => ActionChip(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: StatefulBuilder(
                                          builder: (context, newStateSetter) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            DropdownButton(
                                                value: letter.multiplier,
                                                items: ["1x", "2x", "3x"]
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                              value: int.parse(
                                                                  e.replaceAll(
                                                                      "x", "")),
                                                              child: Text(e),
                                                            ))
                                                    .toList(),
                                                onChanged: (newChoice) {
                                                  letter.multiplier =
                                                      newChoice ?? 1;

                                                  points = 0;
                                                  for (int i = 0;
                                                      i < letters.length;
                                                      i++) {
                                                    points += (int.tryParse(
                                                                (pointMap[letters[
                                                                            i]
                                                                        .char
                                                                        .toLowerCase()])
                                                                    .toString()) ??
                                                            0) *
                                                        letters[i].multiplier;
                                                  }
                                                  points *= multiplier;
                                                  newStateSetter(
                                                    () {},
                                                  );
                                                  stateSetter(() {});
                                                }),
                                          ],
                                        );
                                      }),
                                    ),
                                  );
                                },
                                label: Text(
                                    "${letter.char} - ${(pointMap[letter.char.toLowerCase()] ?? 0) * letter.multiplier}")),
                          )
                          .toList()),
                  const SizedBox(height: 20),
                  Text("Points: $points"),
                  const SizedBox(height: 20),
                  Text("New Total: ${player.score + points}"),
                  ElevatedButton(
                    onPressed: () {
                      player.add(points);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text('Add'),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setup(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.black,
              title: const Text("Scabble"),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: StatefulBuilder(builder: (context, stateSet) {
                          return ListView(children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog.adaptive(
                                    title: const Text(
                                        "Are sure you would like to reset your points"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel")),
                                      ElevatedButton(
                                        onPressed: () {
                                          pointMap = Map.from(defaultPoints);
                                          stateSet(() {});
                                          Navigator.pop(context);

                                          saveData.setString(
                                              "points", jsonEncode(pointMap));
                                        },
                                        child: const Text("Reset"),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                            ),
                            ...pointMap.keys
                                .map(
                                  (e) => Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e.toString().toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                      Expanded(
                                        child: DropdownButton(
                                            value: pointMap[e],
                                            items: List<int>.generate(
                                                    30, (i) => i + 1)
                                                .map((e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(e.toString()),
                                                    ))
                                                .toList(),
                                            onChanged: (newVal) {
                                              pointMap[e] =
                                                  newVal ?? pointMap[e];
                                              stateSet(() {});

                                              saveData.setString("points",
                                                  jsonEncode(pointMap));
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                                .toList()
                          ]);
                        }),
                      ),
                    );
                  },
                  icon: const Icon(Icons.abc),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                TextEditingController name = TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Inputfield(controller: name, hintText: "Name"),
                          ElevatedButton(
                            child: const Text("Add"),
                            onPressed: () {
                              if (name.text.isEmpty) return;
                              players.add(
                                ScrabblePlayer(name: name.text),
                              );
                              Navigator.pop(context);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
              scrollDirection: (MediaQuery.of(context).size.height >=
                      MediaQuery.of(context).size.width)
                  ? Axis.vertical
                  : Axis.horizontal,
              children: players
                  .map(
                    (player) => Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: SizedBox()),
                          Expanded(
                              child: FittedBox(
                                  child: Text(
                            player.name,
                            textAlign: TextAlign.center,
                          ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => editDialog("Add", player),
                                child: const Text("Add"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () {}, child: const Text("Remove"))
                            ],
                          ),
                          Expanded(
                              child: FittedBox(child: Text(player.score.text))),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }
}

class ScrabblePlayer {
  final String name;
  late TextEditingController score;

  ScrabblePlayer({required this.name, score}) {
    this.score = score ?? TextEditingController(text: "0");
  }

  void add(int amount) =>
      score.text = (int.parse(score.text) + amount).toString();

  void subtract(int amount) =>
      score.text = (int.parse(score.text) - amount).toString();
}

class Character {
  final String char;
  int multiplier;

  Character({required this.char, this.multiplier = 1});
}
