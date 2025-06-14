import 'package:flutter/material.dart';
import 'package:workforce_iq/db/database_helper.dart';
import 'package:workforce_iq/screens/login_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String? selectedWilaya;
  int? selectedDepartmentId;
  List<Map<String, dynamic>> departments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDepartments();
    });
  }

  Future<void> _loadDepartments() async {
    final db = await DatabaseHelper.instance.database;
    departments = await db.query('departments');
    setState(() {});
  }

  Future<void> _saveSettings() async {
    if (selectedWilaya != null && selectedDepartmentId != null) {
      await DatabaseHelper.instance
          .saveSettings(selectedWilaya!, selectedDepartmentId!);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Row(
            children: [
              // Left side: Blue panel
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 21, 70, 174),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'WORKFORCE-IQ',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(
                          color: Colors.white,
                          thickness: 2,
                          indent: 200,
                          endIndent: 200),
                      SizedBox(height: 32),
                      Text(
                        'Bienvenue sur votre plateforme de gestion',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "WORKFORCE-IQ est une solution complète pour optimiser "
                        "la gestion de votre personnel et améliorer l'efficacité opérationnelle.",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Comment accéder à l'application:\n\n"
                        "1. Sélectionnez votre wilaya dans le menu déroulant\n"
                        "2. Choisissez le service concerné\n"
                        "3. Cliquez sur \"ACCÉDER AU LOGIN\" pour continuer",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      Spacer(),
                      Center(
                        child: Text(
                          '© 2025 WORKFORCE-IQ. OPP/ Cheloufi Youcef Ouassim.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // Right side: Form
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Configuration Initiale',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1f2937),
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// Wilaya
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('WILAYA',
                            style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedWilaya,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Sélectionnez une wilaya',
                          ),
                          items: [
                            'Adrar',
                            'Chlef',
                            'Laghouat',
                            'Oum El Bouaghi',
                            'Batna',
                            'Bejaia',
                            'Biskra',
                            'Bechar',
                            'Blida',
                            'Bouira',
                            'Tamanrasset',
                            'Tebessa',
                            'Tlemcen',
                            'Tiaret',
                            'Tizi Ouzou',
                            'Alger',
                            'Djelfa',
                            'Jijel',
                            'Setif',
                            'Saida',
                            'Skikda',
                            'Sidi Bel Abbes',
                            'Annaba',
                            'Guelma',
                            'Constantine',
                            'Medea',
                            'Mostaganem',
                            'Msila',
                            'Mascara',
                            'Ouargla',
                            'Oran',
                            'El Bayadh',
                            'Illizi',
                            'Bordj Bou Arreridj',
                            'Boumerdes',
                            'El Tarf',
                            'Tindouf',
                            'Tissemsilt',
                            'El Oued',
                            'Khenchela',
                            'Souk Ahras',
                            'Tipaza',
                            'Mila',
                            'Ain Defla',
                            'Naama',
                            'Ain Temouchent',
                            'Ghardaia',
                            'Relizane',
                            'Timimoun',
                            'Bordj Badji Mokhtar',
                            'Ouled Djellal',
                            'Beni Abbes',
                            'In Salah',
                            'In Guezzam',
                            'Touggourt',
                            'Djanet',
                            'El Mghair',
                            'El Menia'
                          ]
                              .map((w) =>
                                  DropdownMenuItem(value: w, child: Text(w)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedWilaya = value),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Department
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('SERVICE',
                            style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<int>(
                          value: selectedDepartmentId,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Sélectionnez un service',
                          ),
                          onChanged: (value) =>
                              setState(() => selectedDepartmentId = value),
                          items: departments
                              .map((dept) => DropdownMenuItem<int>(
                                    value: dept['id'],
                                    child: Text(dept['name']),
                                  ))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveSettings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 13, 78, 131),
                                minimumSize: const Size.fromHeight(45),
                              ),
                              child: const Text(
                                'ACCÉDER AU LOGIN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 239, 243),
                                minimumSize: const Size.fromHeight(45),
                              ),
                              child: const Text(
                                'QUITTER',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 158, 49, 49),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
