import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateUserData(); // Llamar al método para cargar la información del usuario
  }

  // Método para actualizar datos del usuario
  Future<void> _updateUserData() async {
    setState(() {
      isLoading = true;
    });

    await _loadUserData(); // Cargar datos para el usuario actual

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
            await _firestore.collection('Usuarios').doc(user.uid).get();

        setState(() {
          userData = userDataSnapshot.data() ?? {};
        });
      } catch (e) {
        print("Error al cargar los datos: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      Expanded(flex: 2, child: _TopPortion(userData)),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                userData['username'] ?? 'Nombre predeterminado',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF273469),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const SizedBox(height: 16),
                              ListTile(
                                leading: Icon(Icons.email, color: Colors.black),
                                title: Text(
                                  userData['email'],
                                  style: TextStyle(
                                    color: Color(0xFF273469),
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.phone,
                                  color: Color(0xFF273469),
                                ),
                                title: Text(
                                  userData['telefono'],
                                  style: TextStyle(
                                    color: Color(0xFF273469),
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  userData['direccion'],
                                  style: TextStyle(
                                    color: Color(0xFF273469),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Flecha de retroceso en la esquina superior derecha
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new),
                      color: Colors.white.withOpacity(0.5),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  final Map<String, dynamic> userData;

  const _TopPortion(this.userData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF273469), Color(0xFF273469)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFFAFAFF),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/perfil.png'),
                      )),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
