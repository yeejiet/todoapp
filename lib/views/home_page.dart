import 'package:flutter/material.dart';
import 'package:todoapp/controllers/alert_dialog_controller.dart';
import 'package:todoapp/controllers/to_do_controller.dart';
import 'package:todoapp/models/enums/CRUD.dart';
import 'package:todoapp/views/manage_to_do_page.dart';
import 'package:todoapp/views/to_do_list_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ToDoController toDoController = ToDoController();
  final AlertDialogController alertDialogController = AlertDialogController();
  final TextEditingController tTextController = TextEditingController();
  final TextEditingController dTextController = TextEditingController();
  final PageController pageController = PageController();
  
  int currentPageIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.access_alarms_sharp,
              color: Colors.grey,
            ),  // Replace with the desired icon
            SizedBox(width: 8),  // Adjust the spacing between the icon and the title
            Text("Flutter To Do App"),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            FocusScope.of(context).unfocus();
            currentPageIndex = index;
          });
        },
        children: [
          ToDoListView(
            toDoController: toDoController,
            alertDialogController: alertDialogController,
            tTextController: tTextController,
            dTextController: dTextController,
            pageController: pageController,
          ),

          ManageToDoPage(
            toDoController: toDoController, 
            alertDialogController: alertDialogController, 
            tTextController: tTextController, 
            dTextController: dTextController, 
            pageController: pageController, 
            crud: CRUD.C
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          pageController.animateToPage(
            index, 
            duration: const Duration(milliseconds: 500), 
            curve: Curves.easeInOut,
            );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list,),
            label: "To Do List",
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add To Do",
            backgroundColor: Colors.grey,
          )
        ],
        selectedItemColor: Colors.blueGrey,  // Color of the selected item
        unselectedItemColor: Colors.grey,    // Color of the unselected items
        // Set the label text style
        selectedLabelStyle: const TextStyle(color: Colors.blueGrey),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
      )
    );
  }
}