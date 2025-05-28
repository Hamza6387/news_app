import 'package:hive/hive.dart';

part 'user.g.dart';

// This class represents a user in our app
// Since we don't have a backend, we'll keep it simple
@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String name;

  User({
    required this.email,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}
