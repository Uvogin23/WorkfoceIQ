import 'package:flutter/material.dart';
import 'package:workforce_iq/db/database_helper.dart';
import 'package:workforce_iq/models/event.dart';
import 'package:workforce_iq/services/open_file.dart';

class CreateEventDialog extends StatefulWidget {
  final int employeeId;
  final void Function(Event event)? onSave;

  const CreateEventDialog({super.key, required this.employeeId, this.onSave});

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  DateTime? startDate;
  DateTime? endDate;

  final List<String> eventTypes = [
    'Conge',
    'Maladie',
    'Mission',
    'Permission',
    'Formation',
    'Absent'
  ];

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() &&
        startDate != null &&
        endDate != null &&
        selectedType != null) {
      final newEvent = Event(
        employeeId: widget.employeeId,
        eventType: selectedType!,
        startDate: startDate!,
        endDate: endDate!,
      );

      final db = await DatabaseHelper.instance;
      await db.createEvent(newEvent);
      await db.updateEmployeeStatus(widget.employeeId, selectedType!);
      await db.createLog(
          'Création d\'évenement de type $selectedType pour ${widget.employeeId}');
      switch (selectedType) {
        case 'Conge':
        /*openWordFileFromAssets(
          'assets/testfile.docx', '${widget.employeeId}Perm.docx');*/
        case 'Permission':
        /*openWordFileFromAssets(
          'assets/testfile.docx', '${widget.employeeId}Perm.docx');*/
      }

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Événement créé avec succès.'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Créer un événement'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                hint: const Text('Type d\'événement'),
                items: eventTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => selectedType = value),
                validator: (value) =>
                    value == null ? 'Veuillez choisir un type' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(startDate == null
                        ? 'Date début'
                        : 'Début: ${startDate!.toIso8601String().split('T').first}'),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(isStart: true),
                    child: const Text('Choisir'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(endDate == null
                        ? 'Date fin'
                        : 'Fin: ${endDate!.toIso8601String().split('T').first}'),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(isStart: false),
                    child: const Text('Choisir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
