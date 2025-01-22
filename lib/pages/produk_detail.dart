import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'produk_edit.dart';
import 'mitems.dart';

class ProdukDetail extends StatefulWidget {
  final ItemModel sw;
  ProdukDetail({required this.sw});

  @override
  State<StatefulWidget> createState() => ProdukDetailState();
}

class ProdukDetailState extends State<ProdukDetail> {
  void deleteProduk(context) async {
    http.Response response = await http.post(
        Uri.parse(BaseUrl.Delete),
        body: {
          'id': widget.sw.id.toString(),
        });
    final data = json.decode(response.body);
    if (data['success']) {
      pesan();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  pesan() {
    Fluttertoast.showToast(
        msg: "Penghapusan Data Berhasil",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Konfirmasi Penghapusan", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Anda yakin menghapus data ini?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Batal", style: TextStyle(fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            ElevatedButton(
              onPressed: () => deleteProduk(context),
              child: Text("Hapus", style: TextStyle(fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Film",
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
        elevation: 10.0,
        actions: [
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: Icon(Icons.delete, size: 28, color: Colors.redAccent),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: Colors.white,
            shadowColor: const Color.fromARGB(255, 46, 0, 252),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.star, 'Id:', widget.sw.id.toString()),
                  _buildDetailRow(Icons.book, 'Judul:', widget.sw.judul),
                  _buildDetailRow(Icons.person, 'Sutradara:', widget.sw.pengarang),
                  _buildDetailRow(Icons.publish, 'Penerbit:', widget.sw.penerbit),
                  _buildDetailRow(Icons.category, 'Kategori:', widget.sw.kategori),  
                  _buildDetailRow(Icons.description, 'Sinopsis:', widget.sw.sinopsis),
                  _buildDetailRow(Icons.calendar_today, 'Tahun Terbit:', "${widget.sw.tahun_terbit}"),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 46, 0, 252),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => ProdukEdit(sw: widget.sw)),
        ),
        child: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 46, 0, 252).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 28, color:const Color.fromARGB(255, 46, 0, 252)),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              '$label $value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
