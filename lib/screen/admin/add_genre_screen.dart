import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_kelompok/Providers/MovieProvider.dart';
import 'package:multi_kelompok/models/genre_model.dart';
import 'package:provider/provider.dart';

class AddGenreScreen extends StatefulWidget {
  const AddGenreScreen({super.key});

  @override
  State<AddGenreScreen> createState() => _AddGenreScreenState();
}

class _AddGenreScreenState extends State<AddGenreScreen> {

  final _nameController = TextEditingController();

  
  @override
  void initState(){
    super.initState();
  }


  void _submitGenre()async{
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama genre tidak boleh kosong')),
      );
      return;
    }

    final newGenre = Genre(name: _nameController.text);

    try {
      await Provider.of<MovieProvider>(context, listen: false)
          .addGenre(newGenre);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Genre berhasil ditambahkan')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan genre: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Genre'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Genre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      _submitGenre();
                    },
                    child: Text(
                      "Tambah",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                       ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(Colors.blueAccent[100]!.value),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
