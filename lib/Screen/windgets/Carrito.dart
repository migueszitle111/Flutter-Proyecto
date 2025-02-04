import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicios_app/Screen/windgets/NotificationsService.dart';

class CarritoScreen extends StatefulWidget {
  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  String selectedPaymentMethod = 'Tarjeta'; // Valor inicial

  @override
  void initState() {
    super.initState();
    NotificationService().initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Carrito').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var cartItems = snapshot.data?.docs ?? [];

          double totalAmount = cartItems.fold(0, (sum, item) {
            var precioStr = item.data()?['precio'] as String?;
            var precio = double.tryParse(precioStr ?? '0') ?? 0;
            return sum + precio;
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF1E2749).withOpacity(0.5),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Carrito de compras',
                  style: TextStyle(
                    color: Color(0xFF1E2749),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index].data();
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.0),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 13),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  "images/${item?['nombreEmpresa']}.png",
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
                                      item?['nombreEmpresa'] ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E2749),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      item?['direccion'] ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF273469),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "\$${item?['precio']}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF273469),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteService(
                                      item, cartItems[index].reference);
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(), // Separador visual
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total: \$${totalAmount.toStringAsFixed(2)} MXN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEC6813),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        _showPaymentDialog(context);
                      },
                      child: Text("Pagar Ahora"),
                    ),
                    SizedBox(height: 36.0),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void deleteService(Map<String, dynamic>? item, DocumentReference reference) {
    reference.delete();
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Confirmar Pago"),
              content: Column(
                children: [
                  Text("Selecciona el método de pago:"),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                    items: ['Tarjeta', 'Efectivo', 'Otro']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(_getPaymentIcon(value)),
                                SizedBox(width: 10),
                                Text(value),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo actual
                    _processPayment(selectedPaymentMethod);
                    _showPaymentConfirmationDialog(context);
                  },
                  child: Text("Confirmar Pago"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPaymentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pago Exitoso"),
          content: Column(
            children: [
              Text("¡Gracias por la compra!"),
              Text("Método de pago: $selectedPaymentMethod"),
              if (selectedPaymentMethod == 'Tarjeta')
                ElevatedButton(
                  onPressed: () {
                    _simulateCardPayment(context);
                  },
                  child: Text("Simular Pago con Tarjeta"),
                ),
              if (selectedPaymentMethod == 'Efectivo')
                ElevatedButton(
                  onPressed: () {
                    _generateCashPaymentTicket(context);
                  },
                  child: Text("Generar Ticket de Pago"),
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Mostrar notificación después de confirmar el pago
                NotificationService().showNotification(
                  title: 'Pago Exitoso',
                  body: '¡Servicio contratado!',
                );
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  IconData _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod) {
      case 'Tarjeta':
        return Icons.credit_card;
      case 'Efectivo':
        return Icons.money;
      case 'Otro':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }

  void _processPayment(String paymentMethod) {
    print("Procesando pago con $paymentMethod...");
  }

  void _simulateCardPayment(BuildContext context) {
    // Simulación de proceso de pago con tarjeta
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ingresar Información de Tarjeta"),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Número de Tarjeta'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Fecha de Expiración'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Código de Seguridad'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Aquí deberías validar la información de la tarjeta y realizar la transacción
                print("Información de tarjeta ingresada");
                Navigator.pop(context);
              },
              child: Text("Pagar"),
            ),
          ],
        );
      },
    );
  }

  void _generateCashPaymentTicket(BuildContext context) {
    // Simulación de generación de ticket de pago en efectivo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ticket de Pago en Efectivo"),
          content: Text("Presenta este ticket al pagar en efectivo."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
