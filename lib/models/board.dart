import 'package:trello_like_app/models/item.dart';

class Board {
  //
  int id;
  String name;
  List<Item> items;

  Board({required this.id, required this.name, required this.items});
}
