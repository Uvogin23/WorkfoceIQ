import 'package:flutter/material.dart';
import 'package:workforce_iq/db/database_helper.dart';
import 'package:workforce_iq/models/employee.dart';
import 'package:workforce_iq/widgets/app_bar.dart';

class WorkforceDashboard extends StatefulWidget {
  const WorkforceDashboard({super.key});

  @override
  State<WorkforceDashboard> createState() => _WorkforceDashboardState();
}

class _WorkforceDashboardState extends State<WorkforceDashboard> {
  int total = 0;
  int available = 0;
  int onLeave = 0;
  int sickLeave = 0;
  int onMission = 0;
  int onHoliday = 0;
  int training = 0;
  int unavailable = 0;
  List<Employee> personnelList = [];
  List<Employee> unavailableEmployees = [];

  double _calcPercentage(int part, int whole) {
    if (whole == 0) return 0;
    return (part / whole * 100).roundToDouble();
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    final db = DatabaseHelper.instance;
    total = await db.getTotalEmployees();
    available = await db.getAvailableEmployees();
    onLeave = await db.getEmployeesByStatus('Conge');
    sickLeave = await db.getEmployeesByStatus('Maladie');
    onMission = await db.getEmployeesByStatus('Mission');
    onHoliday = await db.getEmployeesByStatus('Permission');
    training = await db.getEmployeesByStatus('Formation');
    unavailable = await db.getEmployeesByStatus('absent');
    personnelList = await db.getAvailableEmployeesList();
    unavailableEmployees = await db.getUnavailableEmployeesList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: CustomAppBar(context: context),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 1000;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 3000),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, bottom: 40, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SWMT Djanet Dashboard',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Aperçu de l\'état actuel de votre équipe'),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double totalWidth = constraints.maxWidth;
                          double spacing = 20;
                          int itemsPerRow = 4;
                          double itemWidth =
                              (totalWidth - (spacing * (itemsPerRow - 1))) /
                                  itemsPerRow;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: [
                              _buildCard(itemWidth,
                                  title: 'Workforce Totale',
                                  value: '$total',
                                  subText: 'Disponible: $available',
                                  icon: Icons.groups,
                                  bgColor:
                                      const Color.fromARGB(255, 117, 74, 219)),
                              _buildCard(itemWidth,
                                  title: 'Pourcentage',
                                  value:
                                      '${_calcPercentage(available, total)}% ',
                                  subText: '$available de $total disponibles',
                                  bgColor: Colors.green,
                                  icon: Icons.pie_chart),
                              _buildCard(itemWidth,
                                  title: 'Congés',
                                  value: '$onLeave',
                                  subText:
                                      '${_calcPercentage(onLeave, total)}% du total',
                                  icon: Icons.calendar_today,
                                  bgColor: Colors.orange),
                              _buildCard(itemWidth,
                                  title: 'Maladies',
                                  value: '$sickLeave',
                                  subText:
                                      '${_calcPercentage(sickLeave, total)}% du total',
                                  icon: Icons.warning,
                                  bgColor: Colors.red),
                              _buildCard(itemWidth,
                                  title: 'Missions',
                                  value: '$onMission',
                                  subText:
                                      '${_calcPercentage(onMission, total)}% du total',
                                  icon: Icons.cases_sharp,
                                  bgColor: Colors.blue),
                              _buildCard(itemWidth,
                                  title: 'Permissions',
                                  value: '$onHoliday',
                                  subText:
                                      '${_calcPercentage(onHoliday, total)}% du total',
                                  icon: Icons.flight,
                                  bgColor: Colors.purpleAccent),
                              _buildCard(itemWidth,
                                  title: 'Formations',
                                  value: '$training',
                                  subText:
                                      '${_calcPercentage(training, total)}% du total',
                                  icon: Icons.school,
                                  bgColor: Colors.greenAccent),
                              _buildCard(itemWidth,
                                  title: 'Non Disponible',
                                  value: '$unavailable',
                                  subText:
                                      '${_calcPercentage(unavailable, total)}% du total',
                                  icon: Icons.block,
                                  bgColor: Colors.grey),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                      isWideScreen
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: PersonnelList(
                                      title: 'Personnel non Disponible',
                                      isAvailable: false,
                                      personnel: unavailableEmployees),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: PersonnelList(
                                      title: 'Personnel Disponible',
                                      isAvailable: true,
                                      personnel: personnelList),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                PersonnelList(
                                    title: 'Personnel non Disponible',
                                    isAvailable: false,
                                    personnel: unavailableEmployees),
                                const SizedBox(height: 16),
                                PersonnelList(
                                  title: 'Personnel Disponible',
                                  isAvailable: true,
                                  personnel: personnelList,
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: CustombottomNavigationBar(
          context: context,
        ));
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subText;
  final IconData? icon;
  final Color bgColor;
  final Color? barColor;

  const StatusCard(
      {super.key,
      required this.title,
      required this.value,
      this.subText,
      this.icon,
      required this.bgColor,
      this.barColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: bgColor, blurRadius: 0, offset: const Offset(-4, 0))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                if (subText != null)
                  Text(subText!, style: TextStyle(color: Colors.grey[600])),
                if (barColor != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(
                        value: double.parse(value.replaceAll('%', '')) / 100,
                        color: barColor),
                  )
              ],
            ),
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: bgColor,
                ),
              ),
          ],
        ));
  }
}

class PersonnelList extends StatelessWidget {
  final String title;
  final bool isAvailable;
  final List<Employee> personnel;

  const PersonnelList({
    super.key,
    required this.title,
    required this.isAvailable,
    required this.personnel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar with title and color
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isAvailable
                  ? const Color.fromARGB(255, 30, 168, 35)
                  : Colors.red,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            itemCount: personnel.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final p = personnel[index];
              var daysSinceArrival = 0;
              return FutureBuilder<String>(
                future: getEndDate(p.id!),
                builder: (context, snapshot) {
                  // ignore: unused_local_variable
                  Color? tileBgColor;

                  if (!isAvailable &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    final endDate = DateTime.tryParse(snapshot.data!);
                    if (endDate != null &&
                        (endDate.isBefore(DateTime.now()) ||
                            endDate.isAtSameMomentAs(DateTime.now()))) {
                      tileBgColor = const Color.fromARGB(255, 235, 213, 216);
                    }
                  }

                  return Container(
                    color: () {
                      if (isAvailable) {
                        // ignore: unnecessary_null_comparison
                        if (p.arrivalDate != null) {
                          daysSinceArrival =
                              DateTime.now().difference(p.arrivalDate).inDays;
                          if (daysSinceArrival >= 45) {
                            return const Color.fromARGB(255, 155, 222, 157);
                          } else if (daysSinceArrival >= 40 &&
                              daysSinceArrival <= 44) {
                            return const Color.fromARGB(255, 237, 166, 90);
                          }
                        }
                      } else {
                        // If unavailable, color based on end date logic
                        final endDate = DateTime.tryParse(snapshot.data ?? '');
                        if (endDate != null &&
                            (endDate.isBefore(DateTime.now()))) {
                          return const Color.fromARGB(255, 240, 110, 110);
                        }
                      }
                      return null; // Default background
                    }(),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/employee', arguments: p);
                      },
                      leading: CircleAvatar(
                        backgroundColor: isAvailable
                            ? const Color.fromARGB(255, 30, 168, 35)
                            : Colors.red,
                        child: const Icon(
                          Icons.person,
                        ),
                      ),
                      title: Text(p.name),
                      subtitle: isAvailable
                          ? Text(
                              '${p.rank} • ${p.office} • ${p.arrivalDate.toIso8601String().split('T').first}')
                          : snapshot.connectionState == ConnectionState.waiting
                              ? const Text('Chargement...')
                              : snapshot.hasError
                                  ? const Text('Erreur')
                                  : Text(
                                      '${p.office} • ${p.status} • Retour: ${formatDate(snapshot.data ?? '')}'),
                      trailing: isAvailable
                          ? Chip(
                              label: Text('$daysSinceArrival jours'),
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 243, 241),
                            )
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildCard(
  double width, {
  required String title,
  required String value,
  String? subText,
  IconData? icon,
  required Color bgColor,
  Color? barColor,
}) {
  return SizedBox(
    width: width,
    child: StatusCard(
      title: title,
      value: value,
      subText: subText,
      icon: icon,
      bgColor: bgColor,
      barColor: barColor,
    ),
  );
}

Future<String> getEndDate(int employeeId) async {
  final db = DatabaseHelper.instance;
  String? res = await db.getActiveEventEndDate(employeeId);
  return res ?? 'N/A';
}

String formatDate(String dateStr) {
  if (dateStr == 'N/A' || dateStr.isEmpty) {
    return 'N/A';
  } else {
    final date = DateTime.parse(dateStr);
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

//Text(   '${p.office} • ${p.status} • Retour: ${getEndDate(p.id!)}}'),