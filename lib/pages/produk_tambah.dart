import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

// Enum for Category
enum Category { Aksi, Komedi, Drama, Horor, Romantis, Petualangan }

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.Aksi:
        return 'Aksi';
      case Category.Komedi:
        return 'Komedi';
      case Category.Drama:
        return 'Drama';
      case Category.Horor:
        return 'Horor';
      case Category.Romantis:
        return 'Romantis';
      case Category.Petualangan:
        return 'Petualangan';
      default:
        return '';
    }
  }
}

class ProdukTambah extends StatefulWidget {
  const ProdukTambah({super.key});

  @override
  State<StatefulWidget> createState() => ProdukTambahState();
}

class ProdukTambahState extends State<ProdukTambah> {
  final formkey = GlobalKey<FormState>();
  TextEditingController judulController = TextEditingController();
  TextEditingController pengarangController = TextEditingController();
  TextEditingController penerbitController = TextEditingController();
  TextEditingController sinopsisController = TextEditingController();
  TextEditingController tahunTerbitController = TextEditingController();

  Category? selectedCategory = Category.Aksi; 

  // Create a function to send data to the API
  Future createSw() async {
    return await http.post(
      Uri.parse(BaseUrl.Insert),
      body: {
        'judul': judulController.text,
        'pengarang': pengarangController.text,
        'penerbit': penerbitController.text,
        'kategori': selectedCategory!.name,  
        'sinopsis': sinopsisController.text,
        'tahun_terbit': tahunTerbitController.text,
      },
    );
  }

  void _onConfirm(context) async {
    if (formkey.currentState!.validate()) {
      http.Response response = await createSw();
      final data = json.decode(response.body);
      if (data['success']) {
        Fluttertoast.showToast(
          msg: "Data berhasil ditambahkan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: const Color.fromARGB(255, 0, 255, 8),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
          msg: "Terjadi kesalahan, coba lagi.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        tahunTerbitController.text = pickedDate.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Film Baru",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 46, 0, 252), Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueGrey[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField("Judul", Icons.title, judulController),
                _buildInputField("Sutradara", Icons.person, pengarangController),
                _buildInputField("Penerbit", Icons.business, penerbitController),
                _buildCategoryDropdown(),
                _buildInputField("Sinopsis", Icons.description, sinopsisController, maxLines: 3),
                _buildDateField(context), 
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _onConfirm(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 0, 252),
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Tambah", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: tahunTerbitController,
          enabled: false, 
          decoration: const InputDecoration(
            labelText: "Tahun Terbit",
            prefixIcon: Icon(Icons.calendar_today),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pilih Tahun Terbit!';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<Category>(
        value: selectedCategory,
        onChanged: (Category? newCategory) {
          setState(() {
            selectedCategory = newCategory; 
          });
        },
        items: Category.values
            .map((Category category) => DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                ))
            .toList(),
        decoration: const InputDecoration(
          labelText: "Kategori",
          prefixIcon: Icon(Icons.category),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
        validator: (value) {
          if (value == null) {
            return 'Pilih Kategori!';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }
}
