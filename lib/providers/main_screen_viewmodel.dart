import 'package:flutter/material.dart';
import 'package:trello_like_app/models/board.dart';
import 'package:trello_like_app/models/item.dart';
import 'package:uuid/uuid.dart';

class MainScreenViewModel extends ChangeNotifier {
  List<Board> _boards = <Board>[];
  List<Board> get getBoards => _boards;

  MainScreenViewModel() {
    loadData();
  }

  List<Item> sampleItems = [
    Item(
      id: "asdffdasdfa",
      name: "Item 0",
    ),
    Item(
      id: "dafjknsks",
      name: "Item 1",
    ),
    Item(
      id: "adsfadsfasdfads",
      name: "Item 2",
    ),
  ];

  List<Board> sampleBoards = [
    Board(id: 0, name: "A", items: []),
    Board(id: 1, name: "B", items: []),
    Board(id: 2, name: "C", items: []),
  ];

  loadData() {
    sampleBoards[0].items.addAll(sampleItems);
    _boards.addAll(sampleBoards);
  }

  addItem(String name, int boardId) {
    Item newItem = Item(id: const Uuid().toString(), name: name);

    // find board by id and add item
    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].id == boardId) {
        _boards[i].items.add(newItem);
        print("addItem() - SUCCESS");
      }
    }

    notifyListeners();
  }

  moveItem(Item item, Board currentBoard, bool isToNext) {
    // find targetBoard id
    // todo [refactoring] board id system with string key
    int targetBoardId = isToNext ? currentBoard.id + 1 : currentBoard.id - 1;

    for (int i = 0; i < _boards.length; i++) {
      // remove from current board
      if (_boards[i].id == currentBoard.id) {
        _boards[i].items.remove(item);
        print("moveItem() - item removed from current board");
      }

      // add next/previous board
      if (_boards[i].id == targetBoardId) {
        _boards[i].items.add(item);
        print("moveItem() - item moved to target board");
      }
    }

    notifyListeners();
  }

  bool isLastBoard(Board board) {
    return board.id == _boards[_boards.length].id;
  }

  editItem(Item item, int boardId, String newName) {
    //
    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].id == boardId) {
        print("board found!");
        for (int k = 0; k < _boards[i].items.length; k++) {
          if (_boards[i].items[k].id == item.id) {
            print("item found!");
            _boards[i].items[k].name = newName;
            print("editItem() - item name changed with newName: $newName");
          }
        }
      }
    }
    notifyListeners();
  }
}
