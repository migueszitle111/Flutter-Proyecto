import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SingleItemScreen extends StatefulWidget {
  final String nombreEmpresa;
  final String direccion;
  final String precio;
  final String descripcion;
  final String servicioOfrecido;
  final String horario;

  SingleItemScreen({
    required this.nombreEmpresa,
    required this.precio,
    required this.descripcion,
    required this.servicioOfrecido,
    required this.direccion,
    required this.horario,
  });

  @override
  _SingleItemScreenState createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isFavorite = false;
  double userRating = 0.0;
  String userReview = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateUserData();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationController.forward();
  }

  Future<void> _updateUserData() async {
    setState(() {
      isLoading = true;
    });
    await _loadUserData();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'images/${widget.nombreEmpresa}.png';

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      margin: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, left: 18, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.nombreEmpresa,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: Color(0xFF1E2749),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleFavorite,
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Color(0xFF1E2749),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${widget.precio} MXN',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: Color(0xFF1E2749),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        userRating.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: Color(0xFF1E2749),
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFF1E2749),
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Text(
                              widget.descripcion,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Text(
                              'Servicio Ofrecido:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: Color(0xFF1E2749),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Text(
                              '${widget.servicioOfrecido}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Text(
                              'Dirección:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: Color(0xFF1E2749),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              '${widget.direccion}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Text(
                              'Horario:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: Color(0xFF1E2749),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              '${widget.horario}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              'Reseñas:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: Color(0xFF1E2749),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _buildReviewList(),
                          SizedBox(
                            height: 20,
                          ),
                          _buildReviewSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF1E2749).withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Tu Puntuación",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF273469),
            ),
          ),
          SizedBox(height: 10),
          RatingBar.builder(
            initialRating: userRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                userRating = rating;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
            "Tu Reseña",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF273469),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (text) {
              setState(() {
                userReview = text;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Escribe tu reseña aquí...",
            ),
            maxLines: 4,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50), // Ancho mínimo y alto mínimo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _submitReview,
            child: Text("Enviar Reseña"),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Reseñas')
          .where('nombreEmpresa', isEqualTo: widget.nombreEmpresa)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var reviews = snapshot.data!.docs;

        return Column(
          children: reviews.map((review) => ReviewListItem(review)).toList(),
        );
      },
    );
  }

  void _submitReview() async {
    if (userRating == 0.0 || userReview.isEmpty) {
      _showErrorDialog("Por favor, ingresa una puntuación y una reseña.");
      return;
    }

    CollectionReference reviewsCollection =
        FirebaseFirestore.instance.collection('Reseñas');

    await reviewsCollection.add({
      'nombreEmpresa': widget.nombreEmpresa,
      'username': userData['username'],
      'rating': userRating,
      'review': userReview,
    });

    setState(() {
      userRating = 0.0;
      userReview = '';
    });
  }

  void _toggleFavorite() async {
    CollectionReference favoritesCollection =
        FirebaseFirestore.instance.collection('Favoritos');

    if (isFavorite) {
      await favoritesCollection.doc(widget.nombreEmpresa).delete();
    } else {
      await favoritesCollection.doc(widget.nombreEmpresa).set({
        'nombreEmpresa': widget.nombreEmpresa,
        'precio': widget.precio,
        'descripcion': widget.descripcion,
        'servicioOfrecido': widget.servicioOfrecido,
        'direccion': widget.direccion,
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class ReviewListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> review;

  ReviewListItem(this.review);

  @override
  Widget build(BuildContext context) {
    var data = review.data() as Map<String, dynamic>;
    var username = data['username'];
    var rating = data['rating'];
    var reviewText = data['review'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/perfil.png'),
                backgroundColor: Color(0xFFFAFAFF),
                radius: 24.0,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF273469),
                            fontSize: 18.0,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: rating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 18.0, // Tamaño de las estrellas
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double rating) {},
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(
                        reviewText,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF273469),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
