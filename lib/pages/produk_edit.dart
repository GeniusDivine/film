import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api.dart';
import 'package:http/http.dart' as http;
import 'mitems.dart';
import 'form.dart';

class ProdukEdit extends StatefulWidget {
  final ItemModel sw;

  const ProdukEdit({required this.sw, Key? key}) : super(key: key);

  @override
  State<ProdukEdit> createState() => _ProdukEditState();
}

class _ProdukEditState extends State<ProdukEdit> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController judulController;
  late TextEditingController pengarangController;
  late TextEditingController penerbitController;
  late TextEditingController sinopsisController;
  late TextEditingController tahunTerbitController;
  late Category selectedCategory;

  @override
  void initState() {
    super.initState();

    judulController = TextEditingController(text: widget.sw.judul);
    pengarangController = TextEditingController(text: widget.sw.pengarang);
    penerbitController = TextEditingController(text: widget.sw.penerbit);
    sinopsisController = TextEditingController(text: widget.sw.sinopsis);
    tahunTerbitController = TextEditingController(text: widget.sw.tahun_terbit.toString());

    selectedCategory = Category.values.firstWhere(
      (e) => e.name == widget.sw.kategori,
      orElse: () => Category.Aksi,
    );
  }

  Future<void> editSw() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.Edit),
        body: {
          "id": widget.sw.id.toString(),
          "judul": judulController.text,
          "pengarang": pengarangController.text, 
          "penerbit": penerbitController.text,
          "kategori": selectedCategory.name,
          "sinopsis": sinopsisController.text,
          "tahun_terbit": tahunTerbitController.text,
        }
      );

      final data = json.decode(response.body);

      if (data['success']) {
        _showSuccessToast();
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {
        _showErrorToast("Gagal memperbarui data.");
      }
    } catch (e) {
      _showErrorToast("Terjadi kesalahan: $e");
    }
  }

  void _showSuccessToast() {
    Fluttertoast.showToast(
      msg: "Perubahan data berhasil",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: const Color.fromARGB(255, 0, 255, 8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _onConfirm(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      await editSw();
    } else {
      _showErrorToast("Harap lengkapi semua data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Edit Produk",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 46, 0, 252), Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 10.0,
      actions: [
      ],
    );
  }

  Padding _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: ElevatedButton(
        onPressed: () => _onConfirm(context),
        style: ElevatedButton.styleFrom(
          backgroundColor:const Color.fromARGB(255, 46, 0, 252),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        child: const Text("Simpan", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color.fromARGB(255, 255, 255, 255)!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormCard(),
            const SizedBox(height: 30),
            _buildInstructionText(),
          ],
        ),
      ),
    );
  }

  Card _buildFormCard() {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      shadowColor:const Color.fromARGB(255, 46, 0, 252),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AppForm(
          formkey: formKey,
          judulController: judulController,
          pengarangController: pengarangController,
          penerbitController: penerbitController,
          sinopsisController: sinopsisController,
          tahun_terbitController: tahunTerbitController,
          selectedCategory: selectedCategory,
          onCategoryChanged: (Category newCategory) {
            setState(() {
              selectedCategory = newCategory;
            });
          },
        ),
      ),
    );
  }

  Center _buildInstructionText() {
    return Center(
      child: Text(
        "Periksa data sebelum menyimpan",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
