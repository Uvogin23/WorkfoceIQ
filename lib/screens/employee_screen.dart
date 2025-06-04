import 'package:flutter/material.dart';
import 'package:workforce_iq/db/database_helper.dart';
import 'package:workforce_iq/models/employee.dart';
import 'package:workforce_iq/models/event.dart';
import 'package:workforce_iq/models/log.dart';
import 'package:workforce_iq/services/open_file.dart';
import 'package:workforce_iq/widgets/add_event.dart';
import 'package:workforce_iq/widgets/app_bar.dart';
import 'package:workforce_iq/widgets/edit_employee.dart';
import 'package:intl/intl.dart';

class EmployeeInfoPage extends StatefulWidget {
  const EmployeeInfoPage({super.key});

  @override
  State<EmployeeInfoPage> createState() => _EmployeeInfoPageState();
}

class _EmployeeInfoPageState extends State<EmployeeInfoPage> {
  final TextStyle labelStyle = const TextStyle(fontWeight: FontWeight.bold);
  final TextStyle valueStyle = const TextStyle(fontSize: 16);
  final dateFormat = DateFormat('yyyy-MM-dd');

  Widget buildInfoTile(
      String title, String value, Color bgColor, IconData? icon,
      {double? width}) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor, // Light grey background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(title,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 102, 99, 99), fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Employee employee = ModalRoute.of(context)!.settings.arguments as Employee;
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: CustomAppBar(context: context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(60, 20, 60, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side: title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Information sur l'employé",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Données personnelles et historique des congés",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  const Spacer(), // Push buttons to right

                  // Right side: buttons
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 224, 226, 229),
                          fixedSize: const Size(80, 30),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                  'Êtes-vous sûr de vouloir supprimer cet employé ?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Supprimer',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final db = await DatabaseHelper.instance;
                            await db.deleteEmployee(employee.id!);
                            await db.createLog(
                                'Suppression d\'employe ${employee.name}');

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Employé supprimé avec succès.'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_forever,
                                color: Colors.black, size: 20),
                            SizedBox(width: 2),
                            Text(
                              'Supprimer',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 36, 105, 209),
                          fixedSize: const Size(80, 30),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => EditEmployeeDialog(
                              employee: employee,
                              onSave: (updatedEmployee) async {
                                await DatabaseHelper.instance
                                    .updateEmployee(updatedEmployee);
                                setState(() {
                                  employee = updatedEmployee;
                                });
                                final newLog = Log(
                                  action:
                                      'Modification d\'employe ${updatedEmployee.name}',
                                  timestamp: DateTime.now(),
                                );
                                final db =
                                    await DatabaseHelper.instance.database;

                                await db.insert('logs', newLog.toMap());

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Employé modifié avec succès.'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pushNamed(context, '/employee',
                                    arguments:
                                        updatedEmployee); // Close the dialog after saving
                              },
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_outlined,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 20),
                            SizedBox(width: 4),
                            Text(
                              'Modifier',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 209, 186, 36),
                          fixedSize: const Size(85, 30),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (_) => CreateEventDialog(
                              employeeId: employee.id ?? 0,
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 20),
                            SizedBox(width: 1),
                            Text(
                              'Evénement',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              /// Personnel Details
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 57, 153, 227),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text("Informations Personnelles",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white)),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double totalWidth = constraints.maxWidth;
                            double itemWidth = (totalWidth - (2 * 30)) /
                                3; // 3 items + 2 spacings

                            return Wrap(
                              spacing: 30,
                              runSpacing: 20,
                              children: [
                                buildInfoTile(
                                    "Nom et Prénom",
                                    employee.name,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.abc,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Résidence",
                                    employee.state,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.home,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Date de naissance",
                                    employee.birthday
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.cake_outlined,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Numéro du téléphone",
                                    employee.phoneNumber,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.phone,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Carte professionnelle ",
                                    employee.cardNumber,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.card_membership,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Grade",
                                    employee.rank,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.star,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Matricule",
                                    employee.badgeNumber,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.numbers,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Bureau",
                                    employee.office,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.work,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Arme numero:",
                                    employee.weaponNumber,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.security,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Statut",
                                    translateStatusToFrench(employee.status),
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.card_travel,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Reprise du travail le: ",
                                    employee.arrivalDate
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    const Color.fromARGB(255, 216, 219, 220),
                                    Icons.date_range,
                                    width: itemWidth),
                                buildInfoTile(
                                    "Vague de Congé: ${employee.leaveWave}",
                                    leaveWave(employee.leaveWave),
                                    const Color.fromARGB(255, 107, 178, 235),
                                    Icons.waves,
                                    width: itemWidth),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Leave History Table
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 57, 153, 227),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text("Historique des Evenements",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white)),
                          )),
                      const SizedBox(height: 1),
                      FutureBuilder<List<Event>>(
                        future: DatabaseHelper.instance
                            .getEventsByEmployee(employee.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text(
                                'Erreur lors du chargement des événements.');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Aucun événement trouvé pour cet employé.',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16),
                                ),
                              ),
                            );
                          }

                          final events = snapshot.data!;
                          final screenWidth = MediaQuery.of(context).size.width;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints:
                                  BoxConstraints(minWidth: screenWidth),
                              child: DataTable(
                                columnSpacing: 20,
                                headingRowColor: WidgetStateProperty.all(
                                    Colors.blue.shade100),
                                dataRowColor: WidgetStateProperty.all(
                                    Colors.grey.shade50),
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                columns: const [
                                  DataColumn(label: Text("Type")),
                                  DataColumn(label: Text("Début")),
                                  DataColumn(label: Text("Fin")),
                                  DataColumn(label: Text("Durée")),
                                  DataColumn(label: Text("Statut")),
                                  DataColumn(label: Text("Approvée par")),
                                  DataColumn(label: Text("Actions")),
                                ],
                                rows: events.map((event) {
                                  final duration = event.endDate
                                      .difference(event.startDate)
                                      .inDays;

                                  return DataRow(cells: [
                                    DataCell(buildBadge(
                                      event.eventType,
                                      Colors.amber.shade100,
                                      Colors.orange,
                                    )),
                                    DataCell(Text(
                                        dateFormat.format(event.startDate))),
                                    DataCell(
                                        Text(dateFormat.format(event.endDate))),
                                    DataCell(Text('$duration jours')),
                                    DataCell(buildBadge(
                                      event.isActive == true
                                          ? 'En cours'
                                          : 'Terminé',
                                      event.isActive == true
                                          ? Colors.blue.shade50
                                          : Colors.green.shade50,
                                      event.isActive == true
                                          ? Colors.blue
                                          : Colors.green,
                                    )),
                                    const DataCell(Text("Chef Service")),
                                    DataCell(event.isActive == true
                                        ? Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  final confirm =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: const Text(
                                                          'Confirmation'),
                                                      content: const Text(
                                                          'Êtes-vous sûr de vouloir mettre fin à cet événement ?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: const Text(
                                                              'Annuler'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  true),
                                                          child: const Text(
                                                              'Terminer',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    await DatabaseHelper
                                                        .instance
                                                        .terminateActiveEvent(
                                                            employee.id!);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "Événement terminé avec succès")),
                                                    );
                                                    await DatabaseHelper
                                                        .instance
                                                        .createLog(
                                                            'Termination d\'évenement de type ${event.eventType} pour ${employee.name}');
                                                    setState(() {});
                                                  }
                                                },
                                                icon: const Icon(Icons.done),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  final confirm =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: const Text(
                                                          'Confirmation'),
                                                      content: const Text(
                                                          'Êtes-vous sûr de vouloir supprimer cet événement ?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: const Text(
                                                              'Annuler'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  true),
                                                          child: const Text(
                                                              'Supprimer',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    final db =
                                                        await DatabaseHelper
                                                            .instance;
                                                    await db
                                                        .deleteEvent(event.id!);
                                                    await db.createLog(
                                                        'Suppression d\'évenement de type ${event.eventType} pour ${employee.name}');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Événement supprimé avec succès.'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ),
                                                    );
                                                    setState(() {});
                                                  }
                                                },
                                                icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  openWordFileFromAssets(
                                                      'assets/testfile.docx',
                                                      '${employee.name}.docx');
                                                },
                                                icon: const Icon(
                                                    Icons.file_copy,
                                                    color: Color.fromARGB(
                                                        255, 240, 207, 43)),
                                              ),
                                            ],
                                          )
                                        : const Text("")),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustombottomNavigationBar(
          context: context,
        ));
  }
}

String translateStatusToFrench(String status) {
  switch (status) {
    case 'Available':
      return 'Disponible';
    case 'On Leave':
      return 'En congé';
    case 'Sick Leave':
      return 'Maladie';
    case 'On Mission':
      return 'En mission';
    case 'On Holidays':
      return 'Permission';
    case 'Attending Courses':
      return 'En formation';
    case 'Unavailable':
      return 'Indisponible';
    default:
      return status; // fallback if no match
  }
}

String leaveWave(int wave) {
  switch (wave) {
    case 1:
      return '1 juin au 20 juillet';
    case 2:
      return '21 juillet au 09 septembre';
    case 3:
      return '10 septembre au 29 novembre';
    case 4:
      return '30 novembre au 19 décembre';
    case 5:
      return '20 décembre au 08 fevrier';
    case 6:
      return '15 février au 04 avril';
    case 7:
      return '04 avril au 25 mai';
    default:
      return "Vague non déterminée"; // fallback if no match
  }
}
