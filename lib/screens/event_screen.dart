import 'package:flutter/material.dart';
import 'package:workforce_iq/db/database_helper.dart';
import 'package:workforce_iq/widgets/app_bar.dart';
import 'package:intl/intl.dart';

class EventInfoPage extends StatefulWidget {
  const EventInfoPage({super.key});

  @override
  State<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  final TextStyle labelStyle = const TextStyle(fontWeight: FontWeight.bold);
  final TextStyle valueStyle = const TextStyle(fontSize: 16);
  final dateFormat = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  late Future<List<Map<String, dynamic>>> _futureActiveEvents =
      Future.value([]);
  String? selectedType;
  DateTime? startDate;
  DateTime? endDate;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    _futureActiveEvents =
        DatabaseHelper.instance.getActiveEventsWithEmployeeNames();
  }

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
                        "Historique des événements",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Trouver des Informations ou filtrer  les événements",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  const Spacer(), // Push buttons to right

                  // Right side: buttons
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: const Text(
                        'Evènements actives',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _futureActiveEvents,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('Aucun événement actif trouvé.');
                          }

                          final events = snapshot.data!;
                          final screenWidth = MediaQuery.of(context).size.width;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints:
                                  BoxConstraints(minWidth: screenWidth),
                              child: DataTable(
                                columnSpacing: 30,
                                headingRowColor: WidgetStateProperty.all(
                                    Colors.blue.shade100),
                                dataRowColor: WidgetStateProperty.all(
                                    Colors.grey.shade50),
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                columns: const [
                                  DataColumn(label: Text('ID')),
                                  DataColumn(label: Text('Employé')),
                                  DataColumn(label: Text('Type')),
                                  DataColumn(label: Text('Début')),
                                  DataColumn(label: Text('Fin')),
                                ],
                                rows: events.map((event) {
                                  return DataRow(cells: [
                                    DataCell(
                                        Text(event['event_id'].toString())),
                                    DataCell(
                                        Text(event['employee_name'] ?? '')),
                                    DataCell(Text(event['event_type'] ?? '')),
                                    DataCell(Text(
                                        (event['start_date'] as String)
                                            .split('T')
                                            .first)),
                                    DataCell(Text((event['end_date'] as String)
                                        .split('T')
                                        .first)),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
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
                          child: Text(
                            "Filtres des événements",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Type Dropdown
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Type d\'événement',
                                ),
                                items: [
                                  'Mission',
                                  'Formation',
                                  'Congé',
                                  'Permission',
                                  'Absent',
                                  'Maladie'
                                ]
                                    .map((type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  selectedType = value;
                                },
                              ),

                              const SizedBox(height: 10),

                              // Start Date Picker
                              ElevatedButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    startDate = picked;
                                  }
                                },
                                child:
                                    const Text("Sélectionner la date de début"),
                              ),

                              const SizedBox(height: 10),

                              // End Date Picker
                              ElevatedButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    endDate = picked;
                                  }
                                },
                                child:
                                    const Text("Sélectionner la date de fin"),
                              ),

                              const SizedBox(height: 10),

                              // Active Toggle
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Actif uniquement"),
                                  Switch(
                                    value: isActive,
                                    onChanged: (value) {
                                      isActive = value;
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Submit Button
                              ElevatedButton.icon(
                                onPressed: () {
                                  // You can call your filter logic here
                                  if (_formKey.currentState!.validate()) {
                                    // Filter logic here using selectedType, startDate, endDate, isActive
                                  }
                                },
                                icon: const Icon(Icons.search),
                                label: const Text("Filtrer les événements"),
                              ),
                            ],
                          ),
                        ),
                      ),
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



/** 
 * 
 * 
 * 
 * Card(
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

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 120,
                              columns: const [
                                DataColumn(label: Text("Type")),
                                DataColumn(label: Text("Début")),
                                DataColumn(label: Text("fin")),
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
                                  DataCell(
                                      Text(dateFormat.format(event.startDate))),
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
                                                icon: const Icon(Icons.done)),
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
                                                        'Termination d\'évenement de type ${event.eventType} pour ${employee.name}');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          'Événement supprimé avec succès.'),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    ));
                                                    setState(() {});
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red,
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  /*await generatePdfWithTemplate(
                                                    name: employee.name,
                                                    phone: employee.phoneNumber,
                                                  );*/
                                                  openWordFileFromAssets(
                                                      'assets/testfile.docx',
                                                      '${employee.name}.docx');
                                                },
                                                icon: const Icon(
                                                  Icons.file_copy,
                                                  color: Color.fromARGB(
                                                      255, 240, 207, 43),
                                                )),
                                          ],
                                        )
                                      : const Text("")),
                                ]);
                              }).toList(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
 * / */