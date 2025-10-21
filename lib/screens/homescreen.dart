import 'dart:math';
import 'package:flutter/material.dart';
import 'package:habit_chain/screens/add_habit.dart';
import 'package:habit_chain/widgets/github_grid.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

final rnd = Random(42);
final weeks = 52;
final data = List.generate(weeks * 7, (_) => rnd.nextInt(20));

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit Chain',
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_hometopbtn('Streak'), _hometopbtn('Stats')],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 210,
              width: 390,
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.amber.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 1, color: Colors.amber)),
                            child: Icon(Icons.power),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: Colors.amber)),
                          child: Icon(Icons.check),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ContributionGrid(
                            weeks: weeks,
                            values: data,
                            //estimatedVisibleColumns: 29,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddHabitScreen()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ));
  }
}

Widget _hometopbtn(
  String title,
) {
  return Container(
    height: 60,
    width: 170,
    decoration: BoxDecoration(
        color: Colors.blue.shade300, borderRadius: BorderRadius.circular(10)),
    child: Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
