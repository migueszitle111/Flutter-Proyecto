import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'Tarjeta de crédito';
  bool paymentProcessed = false;

  void updatePaymentMethod(String value) {
    setState(() {
      selectedPaymentMethod = value;
    });
  }

  void processPayment() {
    // Lógica para procesar el cobro según el método de pago seleccionado
    if (selectedPaymentMethod == 'Tarjeta de crédito' ||
        selectedPaymentMethod == 'Transferencia bancaria' ||
        selectedPaymentMethod == 'Pago en OXXO') {
      simulatePaymentProcessing();
    }
  }

  void simulatePaymentProcessing() {
    // Simulación de procesamiento de pago exitoso
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        paymentProcessed = true;
      });
      showPaymentNotification();
    });
  }

  void showPaymentNotification() {
    Fluttertoast.showToast(
      msg: 'Pago realizado con éxito mediante $selectedPaymentMethod',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30.0),
          Container(
            padding: EdgeInsets.only(top: 15.0, left: 15.0),
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              color: Colors.white.withOpacity(0.5),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Precio del pago: \$2300.00 MXN',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 241, 255, 171),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ListTile(
                    title: Text(
                      'Tarjeta de crédito',
                      style:
                          TextStyle(color: Color.fromARGB(255, 241, 255, 171)),
                    ),
                    leading: Radio(
                      value: 'Tarjeta de crédito',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) => updatePaymentMethod(value!),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Transferencia bancaria',
                      style:
                          TextStyle(color: Color.fromARGB(255, 241, 255, 171)),
                    ),
                    leading: Radio(
                      value: 'Transferencia bancaria',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) => updatePaymentMethod(value!),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Pago en OXXO',
                      style:
                          TextStyle(color: Color.fromARGB(255, 241, 255, 171)),
                    ),
                    leading: Radio(
                      value: 'Pago en OXXO',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) => updatePaymentMethod(value!),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: processPayment,
                    child: Text(
                      'Pagar',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 241, 255, 171)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
