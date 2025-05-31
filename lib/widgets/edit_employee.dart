import 'package:flutter/material.dart';
import '../models/employee.dart'; // adjust path

class EditEmployeeDialog extends StatefulWidget {
  final Employee employee;
  final Function(Employee) onSave;

  const EditEmployeeDialog({
    Key? key,
    required this.employee,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditEmployeeDialog> createState() => _EditEmployeeDialogState();
}

class _EditEmployeeDialogState extends State<EditEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController phoneController;
  late TextEditingController cardController;
  late TextEditingController weaponController;

  // Dropdown Selections
  late String selectedState;
  late String selectedRank;
  late String selectedOffice;
  late int selectedLeaveWave;
  late DateTime selectedArrivalDate;

  final List<String> states = [
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
  ];
  final List<String> ranks = [
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
  ];
  final List<String> offices = [
    'Chef Service',
    'Adjoint au Chef de Service',
    'Secretariat',
    'Bureau Informatique',
    'Bureau de video surveillance',
    'Bureau des télécommunications',
    'Bureau d\'exploitation',
    'Bureau des supports techniques'
  ];
  final List<int> leaveWaves = [1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.employee.phoneNumber);
    cardController = TextEditingController(text: widget.employee.cardNumber);
    weaponController =
        TextEditingController(text: widget.employee.weaponNumber);

    selectedState = widget.employee.state;
    selectedRank = widget.employee.rank;
    selectedOffice = widget.employee.office;
    selectedLeaveWave = widget.employee.leaveWave;
    selectedArrivalDate = widget.employee.arrivalDate;
  }

  @override
  void dispose() {
    phoneController.dispose();
    cardController.dispose();
    weaponController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final updatedEmployee = Employee(
        id: widget.employee.id,
        name: widget.employee.name,
        state: selectedState,
        birthday: widget.employee.birthday,
        phoneNumber: phoneController.text,
        rank: selectedRank,
        cardNumber: cardController.text,
        badgeNumber: widget.employee.badgeNumber,
        weaponNumber: weaponController.text,
        arrivalDate: selectedArrivalDate,
        office: selectedOffice,
        status: widget.employee.status,
        leaveWave: selectedLeaveWave,
      );

      widget.onSave(updatedEmployee);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier l\'employé'),
      content: SingleChildScrollView(
        child: Container(
          width: 600,
          height: 500,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedState,
                  items: states
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedState = val!),
                  decoration: const InputDecoration(labelText: 'Résidence'),
                  validator: (value) =>
                      value == null ? 'Veuillez selectioner une Wilaya' : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: selectedRank,
                  items: ranks
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedRank = val!),
                  decoration: const InputDecoration(labelText: 'Grade'),
                  validator: (value) =>
                      value == null ? 'Veuillez selectioner un grade' : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: selectedOffice,
                  items: offices
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedOffice = val!),
                  decoration: const InputDecoration(labelText: 'Bureau'),
                  validator: (value) =>
                      value == null ? 'Veuillez selectioner un bureau' : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<int>(
                  value: selectedLeaveWave,
                  items: leaveWaves
                      .map((w) =>
                          DropdownMenuItem(value: w, child: Text('Vague $w')))
                      .toList(),
                  onChanged: (val) => setState(() => selectedLeaveWave = val!),
                  decoration:
                      const InputDecoration(labelText: 'Vague de congé'),
                  validator: (value) => value == null
                      ? 'Veuillez selectioner une vague de congé'
                      : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration:
                      const InputDecoration(labelText: 'Numéro de téléphone'),
                  validator: (value) => value!.isEmpty
                      ? 'Veuillez Entrer un numéro de téléphone'
                      : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: cardController,
                  decoration:
                      const InputDecoration(labelText: 'Numéro de carte'),
                  validator: (value) => value!.isEmpty
                      ? 'Veuillez Entrer le numéro de la carte'
                      : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: weaponController,
                  decoration:
                      const InputDecoration(labelText: 'Numéro d\'arme'),
                  validator: (value) => value!.isEmpty
                      ? 'Veuillez Entrer le numéro de l\'arme'
                      : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                      'Date d\'arrivée: ${selectedArrivalDate.toIso8601String().split('T').first}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedArrivalDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => selectedArrivalDate = picked);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 224, 226, 229),
            fixedSize:
                const Size(80, 30), // Square size with room for icon + text
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_circle, color: Colors.black, size: 20),
              SizedBox(width: 4),
              Text(
                'Annuler',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 36, 105, 209),
            fixedSize: const Size(80, 30),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _saveForm,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_outlined,
                  color: Color.fromARGB(255, 255, 255, 255), size: 20),
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
      ],
    );
  }
}
