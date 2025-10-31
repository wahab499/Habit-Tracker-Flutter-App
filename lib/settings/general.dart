import 'package:flutter/material.dart';

class General extends StatefulWidget {
  const General({super.key});

  @override
  State<General> createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  bool _onChange = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar.new(
        title: Text(
          'General',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black, offset: Offset(0.5, 0.1),
                        spreadRadius: 0.1, // How much the shadow expands
                        blurRadius: 0.1,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Week Starts On Monday',
                                style: TextStyle(fontSize: 18)),
                            Icon(Icons.arrow_right)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Highlight current day',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black, offset: Offset(0.5, 0.1),
                        spreadRadius: 0.1, // How much the shadow expands
                        blurRadius: 0.1,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show View Mode Bottom Bar',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Week Starts On Monday',
                                style: TextStyle(fontSize: 18)),
                            Icon(Icons.arrow_right)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show Category Filter',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black, offset: Offset(0.5, 0.1),
                        spreadRadius: 0.1, // How much the shadow expands
                        blurRadius: 0.1,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show Streak Count',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show Streak Goal',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show Month Labels',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show Day Labels',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show Categories',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black, offset: Offset(0.5, 0.1),
                        spreadRadius: 0.1, // How much the shadow expands
                        blurRadius: 0.1,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Allow Crashlytics',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                                value: _onChange,
                                onChanged: (value) {
                                  setState(() {
                                    _onChange = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('RC ID', style: TextStyle(fontSize: 18)),
                            Icon(Icons.copy)
                          ],
                        ),
                      ),
                    ],
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
