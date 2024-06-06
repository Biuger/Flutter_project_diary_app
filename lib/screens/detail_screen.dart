import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/diary_entry.dart';
import '../services/api_service.dart';
import 'edit_screen.dart'; 

class DetailScreen extends StatelessWidget {
  final DiaryEntry entry;
  final int ID;

  // Lista de estados de ánimo
  final List<String> _moods = ["Depresión", "Melancolía", "Tranquilidad", "Felicidad", "Euforia"];

  DetailScreen({required this.entry, required this.ID});

  @override
  Widget build(BuildContext context) {
    // Formatear la fecha para mostrar solo la parte de la fecha
    final String formattedDate = DateFormat('yyyy-MM-dd').format(entry.date);

    return Scaffold(
      appBar: AppBar(
        title: Text('Querido diario...',
         style: TextStyle(color: Colors.black)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              entry.content,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Slider(
              value: _moods.indexOf(entry.mood).toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              label: entry.mood,
              onChanged: null, // Esto deshabilita el slider
            ),
            SizedBox(height: 8),
            Text(
              'Estado de ánimo: ${entry.mood}',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    bool? updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEntryScreen(ID: ID, entry: entry),
                      ),
                    );
                    if (updated != null && updated) {
                      
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Editar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar eliminación'),
                          content: Text(
                              '¿Estás seguro de que quieres eliminar esta entrada?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    ).then((confirmed) async {
                      if (confirmed != null && confirmed) {
                        if (entry.id != null) {
                          await Provider.of<ApiService>(context, listen: false)
                              .deleteEntry(entry.id!);
                          Navigator.pop(context, true);
                        } else {
                          print('El ID de la entrada es nulo');
                        }
                      }
                    });
                  },
                  child: Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white, 
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
