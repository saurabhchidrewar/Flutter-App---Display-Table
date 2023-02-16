import 'package:flutter/material.dart';
import 'package:flutterapp/customer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Customer Information'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Customer customerService = Customer();
  List<dynamic>? _allUsers = [];
  List<dynamic>? _foundUsers = [];
  String keyword = "";

  @override
  _initState() {
    _foundUsers = _allUsers;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List? results = [];
    keyword = enteredKeyword;
    if (keyword.isEmpty) {
      results = _allUsers!;
    } else {
      results = _allUsers
          ?.where((user) =>
              user["name"].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });

    print(_foundUsers?.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<List>(
            future: customerService.getAllCustomers(),
            builder: (context, snapshot) {
              // print(snapshot.data);
              _allUsers = snapshot.data?.sublist(0, 30);
              if (snapshot.hasData) {
                if (keyword == "") {
                  _foundUsers = _allUsers;
                }
                return Scaffold(
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      child: (Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 250,
                            child: TextField(
                              onChanged: (value) => _runFilter(value),
                              decoration: const InputDecoration(
                                  labelText: 'Search',
                                  suffixIcon: Icon(Icons.search)),
                            ),
                          ),
                          DataTable(
                            columnSpacing: 10,
                            columns: const [
                              DataColumn(
                                label: Text("Name"),
                              ),
                              // DataColumn(
                              //   label: Text("Address"),
                              // ),
                              DataColumn(
                                label: Text("Email"),
                              ),
                              DataColumn(
                                label: Text("Date of \nBirth"),
                              ),
                            ],
                            rows: [
                              ..._foundUsers!.map<DataRow>(
                                (element) => DataRow(cells: [
                                  DataCell(Text(element['name'].toString())),
                                  // DataCell(
                                  //     Text(element['address'].toString())),
                                  DataCell(Text(element['email'].toString())),
                                  DataCell(Text(element['birthdate']
                                      .toString()
                                      .substring(0, 10))),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
