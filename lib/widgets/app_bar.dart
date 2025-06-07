import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:workforce_iq/models/notification.dart';
import 'package:workforce_iq/db/database_helper.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;

  const CustomAppBar({super.key, required this.context});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  List<NotificationMessage> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final db = DatabaseHelper.instance; // Or DatabaseHelper()
    final result = await db.getNotifications();

    setState(() {
      notifications = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 14, 106, 182),
      leading: const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Icon(
          Icons.groups_3,
          color: Colors.white,
          size: 40,
        ),
      ),
      title: const Text(
        'WorkforceIQ',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: PopupMenuButton(
              tooltip: 'Notifications',
              offset: const Offset(0, 48),
              icon: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -4, end: -4),
                showBadge: notifications.isNotEmpty,
                badgeContent: Text(
                  '${notifications.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                child:
                    const Icon(Icons.notifications_none, color: Colors.white),
              ),
              itemBuilder: (context) => notifications.isNotEmpty
                  ? notifications
                      .map(
                        (n) => PopupMenuItem(
                          padding: EdgeInsets.zero,
                          child: SizedBox(
                            width: 400, // ⬅️ Make this wider as needed
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  n.message,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 101, 101, 101),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                  : [
                      const PopupMenuItem(
                        child: Text("Aucune notification"),
                      ),
                    ],
            )),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.home_rounded),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              const SizedBox(width: 10),
              Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: Colors.white,
                    textStyle: const TextStyle(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  highlightColor: Colors.blue.shade100,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.blue.shade50,
                ),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  tooltip: 'Menu',
                  onSelected: (String value) {
                    switch (value) {
                      case 'Ajouter':
                        Navigator.pushNamed(context, '/addemployee');
                        break;
                      case 'Logs':
                        Navigator.pushNamed(context, '/home');
                        break;
                      case 'historique':
                        Navigator.pushNamed(context, '/eventHistory');
                        break;
                      case 'logout':
                        Navigator.pushReplacementNamed(context, '/');
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'Ajouter',
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              color: Color.fromARGB(255, 201, 200, 200)),
                          SizedBox(width: 10),
                          Text(
                            'Ajouter un employé',
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 132, 220),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'historique',
                      child: Row(
                        children: [
                          Icon(Icons.history,
                              color: Color.fromARGB(255, 201, 200, 200)),
                          SizedBox(width: 10),
                          Text(
                            'Consulter l\'historique',
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 132, 220),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*const PopupMenuItem<String>(
                      value: 'logs',
                      child: Row(
                        children: [
                          Icon(Icons.task,
                              color: Color.fromARGB(255, 201, 200, 200)),
                          SizedBox(width: 10),
                          Text(
                            'consulter les logs',
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 132, 220),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: Color.fromARGB(255, 201, 200, 200)),
                          SizedBox(width: 10),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 132, 220),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustombottomNavigationBar extends StatelessWidget {
  final BuildContext context;

  const CustombottomNavigationBar({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SWMT DJANET 2025',
            style: TextStyle(
              fontSize: 8,
              color: Color.fromARGB(255, 19, 37, 48),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Developed by OPP/Cheloufi Youcef Ouassim',
            style: TextStyle(
              fontSize: 8,
              color: Color.fromARGB(255, 19, 37, 48),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
