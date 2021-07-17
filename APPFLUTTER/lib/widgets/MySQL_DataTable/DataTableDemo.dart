import 'dart:async';

import 'package:flutter/material.dart';
import 'Employees.dart';
import 'Services.dart';
import 'package:geolocator/geolocator.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();

  final String title = "Flutter Data Table";

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  int counter = 0;
  Timer _timer;

  updateCounter() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      // You can also call here any function.
      _addEmployee();
      getCurrentLocation();
      _clearValues();

      setState(() {
        counter = ++counter;
      });
    });
  }

  stopCounter() {
    _timer.cancel();
  }

  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;

  Employee _selectedEmployee;
  bool _isUpdating;
  String _titleProgress;
  var locationMessage = "";
  var latitudeMessage = "";
  var longitudeMessage = "";

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lastposition = await Geolocator.getLastKnownPosition();
    print(lastposition);

    var lat = position.latitude;
    var long = position.longitude;
    print("$lat , $long");
    setState(() {
      locationMessage = "$position";
      latitudeMessage = "$lat";
      longitudeMessage = "$long";
    });
  }

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployees();
    getCurrentLocation();
    _clearValues();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {
        showSnackBar(context, result);
        _getEmployees();
      }
    });
  }

  addPostion() {
    _showProgress('Adding Employee...');
    Services.addEmployee(latitudeMessage, longitudeMessage).then((result) {
      if ('success' == result) {
        //  _getEmployees();
      }
      //_clearValues();
    });
  }

  _addEmployee() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      print("Empty fields");
      return;
    }
    _showProgress('Adding Employee...');
    Services.addEmployee(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees();
      }
      _clearValues();
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title);
      print("Length: ${employees.length}");
      _firstNameController.text = longitudeMessage;
      _lastNameController.text = latitudeMessage;
    });
  }

  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id).then((result) {
      if ('success' == result) {
        setState(() {
          _employees.remove(employee);
        });
        _getEmployees();
      }
    });
  }

  _updateEmployee(Employee employee) {
    _showProgress('Updating Employee...');
    Services.updateEmployee(
            employee.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees();
        setState(() {
          _isUpdating = false;
        });
        _firstNameController.text = latitudeMessage;
        _lastNameController.text = '';
      }
    });
  }

  _setValues(Employee employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;

    setState(() {
      _isUpdating = true;
    });
  }

  _clearValues() {
    _firstNameController.text = longitudeMessage;
    _lastNameController.text = latitudeMessage;
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text("ID"),
                numeric: false,
                tooltip: "This is the employee id"),
            DataColumn(
                label: Text(
                  "FIRST",
                ),
                numeric: false,
                tooltip: "This is the last name"),
            DataColumn(
                label: Text("LAST"),
                numeric: false,
                tooltip: "This is the last name"),
            DataColumn(
                label: Text("DELETE"),
                numeric: false,
                tooltip: "Delete Action"),
          ],
          rows: _employees
              .map(
                (employee) => DataRow(
                  cells: [
                    DataCell(
                      Text(employee.id),
                      onTap: () {
                        print("Tapped " + employee.firstName);
                        _setValues(employee);
                        _selectedEmployee = employee;
                      },
                    ),
                    DataCell(
                      Text(
                        employee.firstName.toUpperCase(),
                      ),
                      onTap: () {
                        print("Tapped " + employee.firstName);
                        _setValues(employee);
                        _selectedEmployee = employee;
                      },
                    ),
                    DataCell(
                      Text(
                        employee.lastName.toUpperCase(),
                      ),
                      onTap: () {
                        print("Tapped " + employee.lastName);
                        _setValues(employee);
                        _selectedEmployee = employee;
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteEmployee(employee);
                        },
                      ),
                      onTap: () {
                        print("Tapped " + employee.id);
                      },
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.play_circle),
            onPressed: () {
              updateCounter();
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              stopCounter();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployees();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: latitudeMessage,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration:
                    InputDecoration.collapsed(hintText: longitudeMessage),
              ),
            ),
            _isUpdating
                ? Row(
                    children: <Widget>[
                      OutlineButton(
                        child: Text('UPDATE'),
                        onPressed: () {
                          _updateEmployee(_selectedEmployee);
                        },
                      ),
                      OutlineButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                : Container(),
            Expanded(
              child: _dataBody(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
          getCurrentLocation();
          _clearValues();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
