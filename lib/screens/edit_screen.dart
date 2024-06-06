import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/diary_entry.dart';
import '../services/api_service.dart';

class EditEntryScreen extends StatefulWidget {
  final DiaryEntry entry;
  final int ID;

  EditEntryScreen({required this.entry, required this.ID});

  @override
  _EditEntryScreenState createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();
  late DateTime _selectedDate;
  bool _isSaving = false;
  late double _currentSliderValue;
  List<String> _moods = [
    "Depresión",
    "Melancolía",
    "Tranquilidad",
    "Felicidad",
    "Euforia"
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.entry.title;
    _contentController.text = widget.entry.content;
    _selectedDate = widget.entry.date.toUtc();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Inicializar el valor del slider basado en el estado de ánimo almacenado
    _currentSliderValue = _moods.indexOf(widget.entry.mood).toDouble();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  Future<void> _saveEntry() async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final DateTime date = DateTime.parse(_dateController.text);
    final int ID = widget.ID;
    final String mood = _moods[_currentSliderValue.round()];

    if (title.isNotEmpty && content.isNotEmpty) {
      setState(() {
        _isSaving = true;
      });

      final updatedEntry = DiaryEntry(
        id: widget.entry.id,
        id_user: ID,
        title: title,
        content: content,
        mood: mood,
        date: date,
      );

      try {
        await Provider.of<ApiService>(context, listen: false)
            .updateEntry(widget.entry.id!, updatedEntry);
        Navigator.pop(context, true);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la entrada: $error')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
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
        title: Text(
          'Querido diario...',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
          SizedBox(height: 16),
          _isSaving
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _saveEntry,
                  child: Text('Actualizar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
