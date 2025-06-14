import 'package:flutter/material.dart';
import 'package:workforce_iq/widgets/app_bar.dart';
import 'package:workforce_iq/db/database_helper.dart';
import 'package:workforce_iq/models/employee.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController badgeNumberController = TextEditingController();
  final TextEditingController weaponNumberController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController telNumberController = TextEditingController();

  String? selectedRank;
  String? selectedDepartment;
  String? selectedState;
  DateTime? selectedDate;
  DateTime? birthday;
  List<Map<String, dynamic>> brigades = [];

  Future<void> _loadBrigadesForCurrentDepartment() async {
    final settings = await DatabaseHelper.instance.getSettings();
    if (settings == null) return;

    final deptId = settings['department_id'] as int;
    final db = await DatabaseHelper.instance.database;

    brigades = await db.query(
      'brigades',
      where: 'department_id = ?',
      whereArgs: [deptId],
    );
    print(brigades.first['name']);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBrigadesForCurrentDepartment();
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final newEmployee = Employee(
        name: nameController.text,
        state: selectedState!,
        birthday: birthday!,
        phoneNumber: telNumberController.text,
        rank: selectedRank!,
        cardNumber: cardNumberController.text,
        badgeNumber: badgeNumberController.text,
        weaponNumber: weaponNumberController.text,
        arrivalDate: selectedDate!,
        office: selectedDepartment!,
      );

      final db = await DatabaseHelper.instance;

      await db.createEmployee(newEmployee);
      await db.createLog('Ajout d\'employe ${newEmployee.name}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Employé ajouter avec succès.')),
      ); // Go back or refresh list
      // Go back to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: CustomAppBar(context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(60, 20, 60, 40),
        child: Center(
          child: Container(
              padding: const EdgeInsets.all(1),
              constraints: const BoxConstraints(maxWidth: 3000),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ajouter un Employé",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Détail personnel et information",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 527,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 67, 67, 67)
                                      .withOpacity(0.2),
                                  offset: const Offset(
                                      2, 3), // vers la droite (x) et en bas (y)
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: const Color.fromARGB(255, 67, 67, 67)
                                      .withOpacity(0.2),
                                  offset: const Offset(2,
                                      -3), // vers la droite (x) et en haut (y)
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ]),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.only(
                              left: 50, right: 50, top: 30, bottom: 30),
                          constraints: const BoxConstraints(maxWidth: 3000),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 67, 67, 67)
                                      .withOpacity(0.2),
                                  offset: const Offset(
                                      2, 3), // vers la droite (x) et en bas (y)
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: const Color.fromARGB(255, 67, 67, 67)
                                      .withOpacity(0.2),
                                  offset: const Offset(2,
                                      -3), // vers la droite (x) et en haut (y)
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ]),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Nom complet field
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              bottom: 4,
                                            ),
                                            child: Text('Nom complet',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: TextFormField(
                                              controller: nameController,
                                              validator: (value) => value!
                                                      .isEmpty
                                                  ? 'Veuillez entrer le nom complet'
                                                  : null,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Saisir le nom complet',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            30), // Add spacing between fields

                                    // Résidence field
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, bottom: 4),
                                            child: Text('Résidence',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: selectedState,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Sélectionner la Wilaya de résidence',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 6),
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
                                                  .map((wilaya) =>
                                                      DropdownMenuItem(
                                                        value: wilaya,
                                                        child: Text(wilaya),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) => setState(
                                                  () => selectedState = value),
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Veuillez choisir une Wilaya'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    // First field: Phone number with label
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, bottom: 4),
                                            child: Text(
                                              'Numero du télephone portable',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: TextFormField(
                                              controller: telNumberController,
                                              validator: (value) => value!
                                                      .isEmpty
                                                  ? 'Veuillez entrer un Numero du télephone'
                                                  : null,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Etrer le Numero du télephone',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            30), // space between the two fields
                                    // Second field: Grade dropdown with label
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, bottom: 4),
                                            child: Text(
                                              'Grade',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: selectedRank,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Selectioner le Grade',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              ),
                                              items: [
                                                'AP',
                                                'BP',
                                                'BCP',
                                                'IP',
                                                'IPP',
                                                'OP',
                                                'OPP',
                                                'CP',
                                                'CPP',
                                                'CDP',
                                                'CTP',
                                                'CTGP'
                                              ]
                                                  .map((rank) =>
                                                      DropdownMenuItem(
                                                          value: rank,
                                                          child: Text(rank)))
                                                  .toList(),
                                              onChanged: (value) => setState(
                                                  () => selectedRank = value),
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Veuillez choisir un grade'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    // Matricule field
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, bottom: 4),
                                            child: Text(
                                              'Matricule',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: TextFormField(
                                              controller: badgeNumberController,
                                              validator: (value) => value!
                                                      .isEmpty
                                                  ? 'Veuillez entrer un matricule'
                                                  : null,
                                              decoration: const InputDecoration(
                                                hintText: 'Etrer le matricule',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 30), // space between fields
                                    // Numero de la carte professionnel field
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, bottom: 4),
                                            child: Text(
                                              'Numero de la carte professionnel',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: TextFormField(
                                              controller: cardNumberController,
                                              validator: (value) => value!
                                                      .isEmpty
                                                  ? 'Veuillez entrer le numero de la carte'
                                                  : null,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Etrer le numero de la carte professionnel',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    // Numero de l'arme field
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, bottom: 4),
                                            child: Text(
                                              'Numero de l\'arme',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  weaponNumberController,
                                              validator: (value) => value!
                                                      .isEmpty
                                                  ? 'Veuillez entrer le numero de l\'arme'
                                                  : null,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Etrer le numero de l\'arme',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            30), // space between the two fields
                                    // Bureau dropdown
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, bottom: 4),
                                            child: Text(
                                              'Bureau',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: selectedDepartment,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Sélectionner la Brigade/Bureau',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                border: InputBorder.none,
                                              ),
                                              items: brigades.map((brigade) {
                                                final name =
                                                    brigade['name'] as String;
                                                return DropdownMenuItem<String>(
                                                  value: name,
                                                  child: Text(name),
                                                );
                                              }).toList(),
                                              onChanged: (value) => setState(
                                                  () => selectedDepartment =
                                                      value),
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Veuillez selectioner un bureau'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: TextButton.icon(
                                          icon: const Icon(
                                            Icons.date_range,
                                            color: Color.fromARGB(
                                                255, 34, 118, 187),
                                          ),
                                          label: Text(
                                              selectedDate == null
                                                  ? 'selectioner la date d\'arriver'
                                                  : selectedDate
                                                      .toString()
                                                      .split(' ')[0],
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            final date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            if (date != null) {
                                              setState(
                                                  () => selectedDate = date);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 30), // space between buttons
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: TextButton.icon(
                                          icon: const Icon(
                                            Icons.cake,
                                            color: Color.fromARGB(
                                                255, 34, 118, 187),
                                          ),
                                          label: Text(
                                              birthday == null
                                                  ? 'selectioner la date de naissance'
                                                  : birthday
                                                      .toString()
                                                      .split(' ')[0],
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            final date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                            );
                                            if (date != null) {
                                              setState(() => birthday = date);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.refresh,
                                          color: Colors.white),
                                      label: const Text(
                                        'Réinitialiser',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255,
                                            18,
                                            84,
                                            165), // optional: different color for reset
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _formKey.currentState?.reset();
                                          nameController.clear();
                                          telNumberController.clear();
                                          badgeNumberController.clear();
                                          cardNumberController.clear();
                                          weaponNumberController.clear();
                                          selectedDate = null;
                                          birthday = null;
                                          selectedRank = null;
                                          selectedDepartment = null;
                                          selectedState = null;
                                          // reset any other form fields or variables here
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                        width: 16), // space between buttons
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.check,
                                          color: Colors.black),
                                      label: const Text(
                                        'Enregistrer',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.amber, // primary color
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() &&
                                            selectedDate != null) {
                                          _saveEmployee();
                                        } else if (birthday == null ||
                                            selectedDate == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Veuillez sélectionner la date d\'arrivée et la date de naissance'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: CustombottomNavigationBar(
        context: context,
      ),
    );
  }
}
