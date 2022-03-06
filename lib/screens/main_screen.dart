import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_like_app/models/board.dart';
import 'package:trello_like_app/models/item.dart';
import 'package:trello_like_app/providers/main_screen_viewmodel.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size dpSize = MediaQuery.of(context).size;
    MainScreenViewModel vm = Provider.of<MainScreenViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project"),
      ),
      body: Container(
        width: dpSize.width,
        height: dpSize.height,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  vm.getBoards.map((e) => BoardWidget(context, vm, e)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// FUNCTIONS
  void showNewItemDialog(
      BuildContext context, MainScreenViewModel vm, int boardId) {
    TextEditingController controller = TextEditingController();
    AlertDialog dialog = AlertDialog(
      title: const Text("Add Item"),
      content: Container(
        child: TextField(
          controller: controller,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            // dismiss
            Navigator.pop(context);
          },
          child: Text("CANCEL"),
        ),
        MaterialButton(
          onPressed: () {
            // save
            vm.addItem(controller.value.text, boardId);
            //
            Navigator.pop(context);
          },
          child: Text("SAVE"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: true,
    );

    print("showNewItemDialog()");
  }

  void showEditItemDialog(
      BuildContext context, MainScreenViewModel vm, Item item, int boardId) {
    TextEditingController controller = TextEditingController();
    AlertDialog dialog = AlertDialog(
      title: const Text("Edit Item"),
      content: Container(
        child: TextField(
          controller: controller..text = item.name,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            // dismiss
            Navigator.pop(context);
          },
          child: Text("CANCEL"),
        ),
        MaterialButton(
          onPressed: () {
            // save
            vm.editItem(item, boardId, controller.value.text);
            //
            Navigator.pop(context);
          },
          child: Text("SAVE"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: true,
    );

    print("showNewItemDialog()");
  }

  /// WIDGETS
  Widget BoardWidget(
      BuildContext context, MainScreenViewModel vm, Board board) {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Container(
        width: 300,
        height: 400,
        color: const Color.fromRGBO(207, 207, 207, 1), // #CFCFCF
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(
                  child: Text(board.name),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: board.items
                      .map((e) => ItemWidget(context, e, board, vm))
                      .toList(),
                ),
              ),
              NewItemWidget(context, vm, board.id),
            ],
          ),
        ),
      ),
    );
  }

  Widget ItemWidget(
      BuildContext context, Item item, Board board, MainScreenViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          width: 250,
          height: 40,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              board.id == 0
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        vm.moveItem(item, board, false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("<"),
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  showEditItemDialog(context, vm, item, board.id);
                },
                child: Text(item.name),
              ),
              board.id == vm.getBoards.last.id
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        vm.moveItem(item, board, true);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(">"),
                      ),
                    ),
            ],
          )),
    );
  }

  Widget NewItemWidget(
      BuildContext context, MainScreenViewModel vm, int boardId) {
    return GestureDetector(
      onTap: () {
        showNewItemDialog(context, vm, boardId);
      },
      child: Container(
        width: 250,
        height: 40,
        color: Colors.white,
        child: const Center(child: Text("+")),
      ),
    );
  }

  //
}
