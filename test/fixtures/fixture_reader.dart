import 'dart:io';

String fixtureReader(String name) {
  return File('test/fixtures/$name').readAsStringSync();
}