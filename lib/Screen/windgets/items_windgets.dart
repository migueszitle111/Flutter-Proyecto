import 'package:flutter/material.dart';
import 'package:servicios_app/Screen/single_item_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsWidget extends StatelessWidget {
  final String nombreEmpresa;
  final String direccion;
  final String precio;
  final String descripcion;
  final String servicioOfrecido;
  final String horario;

  const ItemsWidget({
    Key? key,
    required this.nombreEmpresa,
    required this.direccion,
    required this.precio,
    required this.descripcion,
    required this.servicioOfrecido,
    required this.horario,
  }) : super(key: key);

  Future<void> addToCart(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('Carrito').add({
        'nombreEmpresa': nombreEmpresa,
        'direccion': direccion,
        'precio': precio,
        'descripcion': descripcion,
        'servicioOfrecido': servicioOfrecido,
      });

      // Muestra una alerta de éxito
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Agregado al carrito'),
            content: Text('El servicio se ha agregado al carrito con éxito.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra la alerta
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Manejar errores aquí, como conexión perdida, etc.
      print('Error al agregar al carrito: $e');
      // Muestra una alerta de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error al agregar al carrito'),
            content:
                Text('Ocurrió un error al agregar el servicio al carrito.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra la alerta
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleItemScreen(
              nombreEmpresa: nombreEmpresa,
              precio: precio,
              descripcion: descripcion,
              direccion: direccion,
              servicioOfrecido: servicioOfrecido,
              horario: horario,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFAFAFF),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE4D9FF).withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "images/${nombreEmpresa}.png",
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        nombreEmpresa,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2749),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        direccion,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF273469),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "\$$precio",
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
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                color: Color(0xFF273469),
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  addToCart(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
