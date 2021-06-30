# Rooms
A command-line application that creates rooms and adds occupants to the rooms from the questions asked to the user.

## Getting the application
Clone the repository with: 
`git clone https://github.com/probuse/rooms.git`

Then navigate to **rooms** folder with  `cd rooms`

The application's entry point is `bin/`, library code
in `lib/`, and unit test in `test/`.

## How to run the application

First update dependencies with `dart pub get` in the commanf line

Finally run the application with `dart run bin/rooms.dart --name etwin chwezi`
The above creates two rooms ie **etwin** and **chwezi**
The `--name` indicates that we are passing names of rooms as command line arguments. You can pass one or more names.
You should now be able to interact with the application

## Dependencies
- [Dart](https://dart.dev/)
- [args](https://pub.dev/pack)

## To-dos
- [x] Get information from user
- [x] Enable user to create rooms
- [x] Enable user to add people to rooms


Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
