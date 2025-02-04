import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF1E2749).withOpacity(0.5),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Favoritos',
                  style: TextStyle(
                    color: Color(0xFF1E2749),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Favoritos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    var favoriteServices = snapshot.data?.docs ?? [];

                    return favoriteServices.isNotEmpty
                        ? ListView.builder(
                            itemCount: favoriteServices.length,
                            itemBuilder: (context, index) {
                              var serviceData = favoriteServices[index].data()
                                  as Map<String, dynamic>;

                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  deleteFavoriteService(
                                      favoriteServices[index].reference);
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Color(0xFF273469),
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFFFAFAFF),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFFE4D9FF).withOpacity(0.7),
                                        spreadRadius: 1,
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          "images/${serviceData['nombreEmpresa']}.png",
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              serviceData['nombreEmpresa'] ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E2749),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              serviceData['direccion'] ?? '',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF273469),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "\$${serviceData['precio']}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF273469),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No tienes servicios favoritos.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteFavoriteService(DocumentReference reference) {
    reference.delete();
  }
}
