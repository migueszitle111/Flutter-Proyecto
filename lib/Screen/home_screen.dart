import 'package:flutter/material.dart';
import 'package:servicios_app/Screen/windgets/Carrito.dart';
import 'package:servicios_app/Screen/windgets/home_bottom_bar.dart';
import 'package:servicios_app/Screen/windgets/items_windgets.dart';
import 'package:servicios_app/Screen/login/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();

  List<DocumentSnapshot<Object?>> allProveedores = [];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTableSelection);
    super.initState();
  }

  _handleTableSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _performSearch() {
    setState(() {
      // Actualiza el estado con la lista filtrada de tarjetas
    });
  }

  final Box _boxLogin = Hive.box("login");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarritoScreen(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        color: Color(0xFF1E2749).withOpacity(0.5),
                        size: 30,
                      ),
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          _boxLogin.clear();
                          _boxLogin.put("loginStatus", false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Login();
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.logout_rounded),
                        color: Color(0xFF1E2749).withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "¿Qué es lo que buscas?",
                  style: TextStyle(
                    color: Color(0xFF273469),
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                width: MediaQuery.of(context).size.width,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFE4D9FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _searchController,
                  style: TextStyle(color: Color(0xFF273469)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ingresa servicio que necesitas",
                    hintStyle: TextStyle(
                      color: Color(0xFF273469).withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Color(0xFF273469).withOpacity(0.5),
                    ),
                  ),
                  onChanged: (_) {
                    _performSearch();
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: Color(0xFF1E2749),
                unselectedLabelColor: Color(0xFF1E2749).withOpacity(0.5),
                isScrollable: true,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: Color(0xFF1E2749),
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 16),
                ),
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 20),
                tabs: [
                  Tab(text: "Plomería"),
                  Tab(text: "Electricidad"),
                  Tab(text: "Construcción"),
                  Tab(text: "Limpieza"),
                ],
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future:
                    FirebaseFirestore.instance.collection('Proveedor').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hay datos disponibles'));
                  } else {
                    allProveedores = snapshot.data?.docs ?? [];

                    return Column(
                      children: allProveedores
                          .where((doc) =>
                              doc.data() != null &&
                              (doc.data() as Map<String, dynamic>)
                                  .containsKey('servicioOfrecido') &&
                              (doc.data() as Map<String, dynamic>)[
                                      'servicioOfrecido'] ==
                                  [
                                    "Plomeria",
                                    "Electricidad",
                                    "Construccion",
                                    "Limpieza",
                                  ][_tabController.index])
                          .where((doc) =>
                              _searchController.text.isEmpty ||
                              doc['nombreEmpresa'] != null &&
                                  doc['nombreEmpresa']
                                      .toLowerCase()
                                      .contains(_searchController.text))
                          .map((doc) => ItemsWidget(
                                nombreEmpresa: doc['nombreEmpresa'] ?? "",
                                direccion: doc['direccion'] ?? "",
                                precio: doc['precio'] ?? "",
                                descripcion: doc['descripcion'] ?? "",
                                servicioOfrecido: doc['servicioOfrecido'] ?? "",
                                horario: doc['horario'] ?? "",
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
