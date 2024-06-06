import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/diary_entry.dart';
import '../services/api_service.dart';

class AddEntryScreen extends StatefulWidget {
  final int ID;

  AddEntryScreen({required this.ID});

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _currentSliderValue = 2;
  List<String> _moods = ["Depresión", "Melancolía", "Tranquilidad", "Felicidad", "Euforia"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text = _selectedDate.toUtc().toLocal().toString().split(' ')[0];
      });
  }

  void _saveEntry() async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final DateTime date = DateTime.parse(_dateController.text);
    final String mood = _moods[_currentSliderValue.round()];
    final int id_user = widget.ID;

    if (title.isNotEmpty && content.isNotEmpty) {
      final newEntry = DiaryEntry(
        title: title,
        id_user: id_user,
        content: content,
        date: date,
        mood: mood,
      );
      Provider.of<ApiService>(context, listen: false).createEntry(newEntry);
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos los campos son obligatorios')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Querido diario...'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Contenido'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Seleccionar Fecha'),
            ),
            SizedBox(height: 16),
            Text(
              'Estado de Ánimo: ${_moods[_currentSliderValue.round()]}',
              style: TextStyle(fontSize: 24),
            ),
            Slider(
              value: _currentSliderValue,
              min: 0,
              max: 4,
              divisions: 4,
              label: _moods[_currentSliderValue.round()],
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 36), 
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _selectedDate.toLocal().toString().split(' ')[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
