import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botones Deslizables',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
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

  final List<String> _labels = [
    'Inicio',
    'Pedidos',
    'Favoritos',
    'Cuenta',
    'Más',
    'Config',
    'Ayuda',
    'Historial',
    'Promociones',
  ];

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
  ];

  final List<Widget> _pages = [
    Center(child: Text('Inicio', style: TextStyle(fontSize: 24))),
    Center(child: Text('Pedidos', style: TextStyle(fontSize: 24))),
    Center(child: Text('Favoritos', style: TextStyle(fontSize: 24))),
    Center(child: Text('Cuenta', style: TextStyle(fontSize: 24))),
    Center(child: Text('Más', style: TextStyle(fontSize: 24))),
    Center(child: Text('Configuración', style: TextStyle(fontSize: 24))),
    Center(child: Text('Ayuda', style: TextStyle(fontSize: 24))),
    Center(child: Text('Historial', style: TextStyle(fontSize: 24))),
    Center(child: Text('Promociones', style: TextStyle(fontSize: 24))),
  ];

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Opcional: Auto-scroll para hacer visible el botón seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        (index * 100).toDouble(), // Ajusta este valor según el ancho de tus botones
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
      appBar: AppBar(
        title: Text('Botones Deslizables'),
        centerTitle: true,
      ),
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
}