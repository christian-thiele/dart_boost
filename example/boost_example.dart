import 'package:boost/boost.dart';

class Person {
  final String name;
  final bool clubMember;

  Person(this.name, this.clubMember);
}

void main() {
  final people = [
    Person('Joe', false),
    Person('Alex', true),
    Person('Grace', true),
    Person('Tina', false),
    Person('Max', false),
  ];

  final split = people.split((p) => p.clubMember);
  print('${split.a.length} people are club Members:');
  split.a.forEach((p) => print(p.name));

  print('${split.b.length} people are not:');
  split.b.forEach((p) => print(p.name));
}
