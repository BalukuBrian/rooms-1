import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';

List<Room> rooms = []; // A room can only have 5 students and one staff member

void getUserInformation(List<String> arguments) {
  var roomNames = _getRoomNamesFromArguments(arguments);
  var newRooms = _createRoomsFromRoomNames(roomNames);
  _updateRooms(newRooms);

  if (rooms.isNotEmpty) {
    while (true) {
      _addPersonToRoom();
    }
  } else {
    print('You did not add any room names\n');
  }
}

List<String> _getRoomNamesFromArguments(List<String> arguments) {
  var roomNames = <String>[];
  var parser = ArgParser();
  parser.addOption('name', abbr: 'n');
  try {
    var results = parser.parse(arguments);
    if (results['name'] != null) {
      roomNames.add(results['name']);
      if (results.rest.isNotEmpty) {
        roomNames.addAll(results.rest);
      }
    }
    return roomNames;
  } catch (e) {
    print('$e');
    exit(0);
  }
}

List<Room> _createRoomsFromRoomNames(List<String> roomNames) {
  if (roomNames.isNotEmpty) {
    return roomNames.map((name) => Room(name)).toList();
  }
  return [];
}

void _updateRooms(List<Room> newRooms) {
  rooms.addAll(newRooms);
  print('${rooms.length} rooms added successfully, add people to your rooms\n');
}

void _addPersonToRoom() {
  var userResponse = getUserResponse(
      'Enter "student" to add student, "staff" to add a staff member');
  if (userResponse.toLowerCase() == 'student') {
    // add student to room
  } else if (userResponse.toLowerCase() == 'staff') {
    // add staff to room
    _addStaffToRoom();
  } else {
    print('Not a valid option, please try again\n');
    _addPersonToRoom();
  }
}

void _addStaffToRoom() {
  print('\nLets add a staff member.');
  var userResponse = getUserResponse('Enter name(s) of staff member to add');
  var staff = Staff(names: userResponse);
  print('');

  // add staff to room
  _selectRoom(staff);
}

void _selectRoom(Person staff, {bool retry = false}) {
  var message = retry
      ? 'Wrong choice, please choose from the names below:'
      : 'The following are the rooms names in our records:';
  print(message);
  print('$allRooms');

  var response = getUserResponse('Select a room to add ${staff.names}');
  // hashCode and operator come in handle here
  var room = Room(response.trim());
  if (rooms.contains(room)) {
    print('');
    room.addPerson(staff);
    print("");
    print("room $room has ${room.occupants.length}");
  } else {
    print('Room $response not found, available rooms are $allRooms\n');
    _selectRoom(staff, retry: true);
  }
}

String get allRooms => rooms.join(', ');

void quitApplication(
    {String title =
        "We have reached the end of our program, enter 'q' or press CTRL+C to quit"}) {
  var quit = getUserResponse(title);
  if (quit.toLowerCase() == 'q') {
    printResults();
    exit(0);
  } else {
    print('This is not one of the provided options');
    print('');
  }
}

String getUserResponse(String question) {
  stdout.write('$question: \n');
  return stdin.readLineSync();
}

/// returns a list of foods from a string of foods separated by space
List<String> getFavoriteFoods(String favoriteFoodString) {
  return favoriteFoodString.split(' ');
}

var retries = 3;
int getUserAge() {
  stdout.write('Enter your age: \n');
  var response = stdin.readLineSync();
  int age;
  try {
    age = int.parse(response);
    return age;
  } catch (e) {
    if (retries > 0) {
      retries -= 1;
      print('Invalid age, you have $retries retries left');
      return getUserAge();
    } else {
      print(
          'Invalid, you have used all your retries, your age wont be captured');
      return null;
    }
  }
}

void printResults() {
  print('\n');
  print('');
}

abstract class Person {
  String names;
}

abstract class Building {
  String name;
  List<Room> rooms;

  void addRoom(Room room);
  void removeRoom(Room room);
}

class Room {
  String name;
  List<Person> occupants = [];

  Room(this.name);

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return other is Room && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  void addPerson(Person person) {
    occupants.add(person);
  }

  void removePerson(Person person) {}
}

class Staff implements Person {
  @override
  String names;

  Staff({this.names});
}

class Hostel implements Building {
  @override
  String name;

  @override
  List<Room> rooms;

  @override
  void addRoom(Room room) {
    // TODO: implement addRoom
  }

  @override
  void removeRoom(Room room) {
    // TODO: implement removeRoom
  }
}

void _createHostel(String name, List<Room> rooms) {
  var hostel = Hostel();
  hostel.name = name;
  hostel.rooms = rooms;
}
