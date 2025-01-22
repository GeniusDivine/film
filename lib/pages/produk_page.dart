import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'produk_detail.dart';
import 'produk_tambah.dart';
import 'api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'mitems.dart';

class ProdukPage extends StatefulWidget {
  @override
  ProdukPage({Key? key}) : super(key: key);
  State<StatefulWidget> createState() {
    return ProdukPageState();
  }
}

class ProdukPageState extends State<ProdukPage> {
  late Future<List<ItemModel>> sw;

  @override
  void initState() {
    super.initState();
    sw = getSwList();
  }

  Future<List<ItemModel>> getSwList() async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.List));
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        return items.map<ItemModel>((json) => ItemModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Film",
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<ItemModel>>(
          future: sw,
          builder: (BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }
            return _buildItemList(snapshot.data!);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 46, 0, 252),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProdukTambah()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: const Color.fromARGB(255, 46, 0, 252),
        strokeWidth: 5.0,
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            'Error: $error',
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.grey, size: 50),
          SizedBox(height: 10),
          Text(
            'Tidak Ada Film yang tercantum ',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<ItemModel> items) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey[300],
      ),
      itemBuilder: (BuildContext context, int index) {
        var data = items[index];
        return Card(
          elevation: 8,
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProdukDetail(sw: data)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 46, 0, 252),
                    child: Icon(Icons.movie, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.judul,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Penerbit: ${data.penerbit}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Sinopsis: ${data.sinopsis}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
