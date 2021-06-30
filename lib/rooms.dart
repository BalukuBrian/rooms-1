import 'dart:core';
import 'dart:io';

import 'package:args/args.dart';

List<Room> rooms = []; // A room can only have 4 occupants

void getUserInformation(List<String> arguments) {
  var roomNames = _getRoomNamesFromArguments(arguments);
  var newRooms = _createRoomsFromRoomNames(roomNames.toSet().toList());
  _updateRooms(newRooms);

  if (rooms.isNotEmpty) {
    print(
        '${rooms.length} rooms added successfully, add people to your rooms\n');
    while (true) {
      _runApplication();
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
}

void _runApplication() {
  var userResponse = _getUserResponse(
      'Enter "student" to add student, "staff" to add a staff member, CTRL+C to quit');
  if (userResponse.toLowerCase() == 'student') {
    // TODO This is your task
    // We have a global variable called rooms
    // rooms contains rooms created from the room names that you passed in the command line
    // Your task is to add students(occupants) to these rooms
    // each room can only have 4 occupants of type Person(this functionality is already implemented
    // you just have to use it in your code)
    // an occupant should not be added to a room more than once.
    // Requirement: when creating the Student class use Person class as Interface
    // Hint one: look at how Staff class implements the interface of Person
    // Hint two: Borrow ideas from the functionality of adding staff. ie run the code and choose staff.
    // Can you reproduce that functionality for the student feature?
    // Feel free to reuse any functions that are already created. Just don't modify them.
    // You can add extra features if you have the above functionality working properly
    // Happy coding
    print('');
    print(
        'This feature is currently not implemented, it is your task to implement it\nEnter staff to view staff feature in action\n');
  } else if (userResponse.toLowerCase() == 'staff') {
    // add staff to room
    _addStaffToRoom();
  } else {
    print('');
    print(
        '$userResponse is not a valid option, please try again\nValid options are student or staff\n');
    _runApplication();
  }
}

void _addStaffToRoom() {
  print('\nLets add a staff member.');
  var userResponse = _getUserResponse('Enter name(s) of staff member to add');
  if (userResponse.isNotEmpty) {
    var staff = Staff(names: userResponse);

    print('');
    _selectRoom(staff);
    _addAnotherStaffMember();
  } else {
    print('Staff member name can not be empty\n');
    _addAnotherStaffMember();
  }
}

void _selectRoom(Person person, {bool retry = false}) {
  var message = retry
      ? 'Wrong choice, please choose from the names below:'
      : 'The following are the rooms names in our records:';
  print(message);
  print('$allRooms\n');

  var response = _getUserResponse('Select a room to add ${person.names}');

  // hashCode and operator come in handle here
  var selectedRoom = Room(response.trim());
  if (rooms.contains(selectedRoom)) {
    print('');
    var currentRoomIndex = rooms.indexOf(selectedRoom);
    var currentRoom = rooms[currentRoomIndex];

    if (currentRoom.occupants.contains(person)) {
      print(
          'Person ${person.names} already exists in room ${currentRoom.name}\n');
    } else {
      var result = currentRoom.addPerson(person);
      print(
          'Room $currentRoom has ${currentRoom.occupants.length} occupant(s)\n');
      if (!result) {
        print(
            'Room ${currentRoom.name} is already full, we can not add any more people\n');
        _selectAFreeRoom(person);
      }
    }
  } else {
    print('Room $response not found, available rooms are $allRooms\n');
    _selectRoom(person, retry: true);
  }
}

void _selectAFreeRoom(Person person) {
  var freeRooms = rooms
      .map((room) => room)
      .where((room) => room.occupants.length < 4)
      .toList();
  print(
      'The following are the free rooms left, select one to add ${person.names}');
  print('${_getRoomsFromListOfRooms(freeRooms)}\n');

  var response = _getUserResponse('Select a room to add ${person.names}');
  var selectedRoom = Room(response.trim());

  if (freeRooms.contains(selectedRoom)) {
    print('');
    var currentRoomIndex = freeRooms.indexOf(selectedRoom);
    var currentRoom = freeRooms[currentRoomIndex];

    if (currentRoom.occupants.contains(person)) {
      print(
          'Person ${person.names} already exists in room ${currentRoom.name}\n');
    } else {
      currentRoom.addPerson(person);
      print(
          'Room $currentRoom has ${currentRoom.occupants.length} occupant(s)\n');
    }
  } else {
    print(
        'Room $response not found, available rooms are ${_getRoomsFromListOfRooms(freeRooms)}\n');
  }
}

void _addAnotherStaffMember() {
  var userResponse =
      _getUserResponse('Do you want to add another staff member? yes/no');
  if (userResponse.toLowerCase() == 'yes') {
    _addStaffToRoom();
  } else if (userResponse.toLowerCase() == 'no') {
    print('Lets continue then ...\n');
  } else {
    print(
        '$userResponse is not a valid option.\nValid options are yes or no\n');
  }
}

/* Helper functions */
String _getUserResponse(String question) {
  stdout.write('$question: \n');
  return stdin.readLineSync();
}

String get allRooms => _getRoomsFromListOfRooms(rooms);
String _getRoomsFromListOfRooms(List<Room> rooms) {
  return rooms.join(', ');
}

/* Classes */
abstract class Person {
  String names;
}

class Staff implements Person {
  @override
  String names;

  Staff({this.names});

  // used to compare if two objects are the same
  @override
  bool operator ==(Object other) {
    return other is Staff && other.names == names;
  }

  // gives hashcode for this object(used when comparing objects)
  @override
  int get hashCode => names.hashCode;
}

class Room {
  String name;
  Set<Person> occupants = {};

  Room(this.name);

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return other is Room && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  bool addPerson(Person person) {
    if (occupants.length < 4) {
      occupants.add(person);
      return true;
    } else {
      return false;
    }
  }
}
