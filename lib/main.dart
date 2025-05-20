import 'package:bottom/screens/form_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App con Drawer, Botones y Formulario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _labels = [
    'Inicio',
    'Pedidos',
    'Favoritos',
    'Formulario', //precionar para ver el formulario
    'Cuenta',
    'Más',
    'Config',
  ];

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.green, // Color para el botón del formulario
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  final List<Widget> _pages = [
    Center(child: Text('Página de Inicio, porfa ir al formulario hasta nuevas acualizaciones , completar todos los campos de formulario', style: TextStyle(fontSize: 24))),
    Center(child: Text('Página de Pedidos', style: TextStyle(fontSize: 24))),
    Center(child: Text('Página de Favoritos', style: TextStyle(fontSize: 24))),
    FormPage(), // Formulario integrado aquí
    Center(child: Text('Página de Cuenta', style: TextStyle(fontSize: 24))),
    Center(child: Text('Página de Más Opciones', style: TextStyle(fontSize: 24))),
    Center(child: Text('Página de Configuración', style: TextStyle(fontSize: 24))),
  ];

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        (index * 100).toDouble(),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildBootstrapButton(String label, Color color, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () => _onButtonTapped(index),
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          backgroundColor: _selectedIndex == index ? color.withOpacity(0.8) : color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: _selectedIndex == index ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          elevation: _selectedIndex == index ? 8 : 4,
          // ignore: deprecated_member_use
          shadowColor: color.withOpacity(0.5),
        ),
        child: Text(
          label, 
          style: TextStyle(
            fontSize: 14,
            fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_labels[_selectedIndex]),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: List.generate(
              _labels.length,
              (index) => _buildBootstrapButton(_labels[index], _colors[index], index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'christoopher jimenez Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'jimenez@demo.com',
                  style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text('Tareas'),
            onTap: () {
              _onButtonTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.red),
            title: Text('Pedidos'),
            onTap: () {
              _onButtonTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.orange),
            title: Text('Favoritos'),
            onTap: () {
              _onButtonTapped(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.green),
            title: Text('Formulario'),
            onTap: () {
              _onButtonTapped(3); // Índice del formulario
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey),
            title: Text('Configuración'),
            onTap: () {
              _onButtonTapped(6);
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.grey),
            title: Text('Cerrar sesión'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}