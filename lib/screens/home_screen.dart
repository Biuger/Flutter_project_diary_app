import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flutter/screens/add_screen.dart';
import '../models/diary_entry.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'login_screen.dart'; 

class HomeScreen extends StatefulWidget {
  final int ID;
  final String username;

  HomeScreen({required this.ID, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<DiaryEntry>> _entriesFuture;
  late int ID = widget.ID;

  @override
  void initState() {
    super.initState();
    _loadEntries();
    Provider.of<ApiService>(context, listen: false).entryNotifier.listen((_) {
      _refreshEntries();
    });
  }

  void _loadEntries() {
    _entriesFuture = Provider.of<ApiService>(context, listen: false).getEntries(ID);
  }

  Future<void> _refreshEntries() async {
    setState(() {
      _loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double fontSize = constraints.maxWidth / 15;
            return Text(
              'Bienvenido de nuevo, ${widget.username}!',
              style: TextStyle(fontSize: fontSize, color: Colors.black),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()), // Ir a la pantalla de inicio de sesión y eliminar todas las rutas anteriores
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DiaryEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tu diario está vacío'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final entry = snapshot.data![index];

                final String formattedDate = DateFormat('yyyy-MM-dd').format(entry.date);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                  child: Card(
                    key: ValueKey(entry),
                    color: Color(0xFFC0D4FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        entry.title,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        formattedDate,
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(ID: ID, entry: entry),
                          ),
                        );
                        _refreshEntries();
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEntryScreen(ID: ID),
            ),
          );
          _refreshEntries();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
