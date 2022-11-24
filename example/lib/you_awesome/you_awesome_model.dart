// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

class YouAwesomeModel extends Equatable {
  const YouAwesomeModel({
    required this.name,
  });
  final String name;

  @override
  List<Object> get props => [ name];

  Map<dynamic, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  static YouAwesomeModel? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return YouAwesomeModel(
      name: map['name']!.toString(),
    );
  }

}

class YouAwesomeViewModel extends Equatable {
  const YouAwesomeViewModel({
    // TODO(all): add all required constructor parameters
    required this.items,
  });

  // TODO(all): declare your fields here
  final List<YouAwesomeModel>? items;

  @override
  List<Object?> get props => [items /*TODO(all): List all fields here*/];

  // TODO(all): implement copyWith
  YouAwesomeViewModel copyWith({
    List<YouAwesomeModel>? items,
  }) {
    return  YouAwesomeViewModel(
        items: items ?? this.items,
      );
  }
}
