import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  String _genero = 'masculino';
  String _estadoCivil = 'soltero';
  bool _aceptaTerminos = false;
  bool _recibirNotificaciones = true;
  DateTime? _fechaNacimiento;

  final List<String> _estadosCiviles = [
    'soltero',
    'casado',
    'divorciado',
    'viudo',
    'unión libre'
  ];

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _fechaNacimientoController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  void _calcularEdad() {
    if (_fechaNacimiento != null) {
      final now = DateTime.now();
      int edad = now.year - _fechaNacimiento!.year;
      if (now.month < _fechaNacimiento!.month ||
          (now.month == _fechaNacimiento!.month && now.day < _fechaNacimiento!.day)) {
        edad--;
      }
      _edadController.text = edad.toString();
    }
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
        _fechaNacimientoController.text = DateFormat('dd/MM/yyyy').format(picked);
        _calcularEdad();
      });
    }
  }

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      if (!_aceptaTerminos) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe aceptar los términos y condiciones')),
        );
        return;
      }

      // Mostrar los datos en un diálogo
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datos del Formulario'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Cédula: ${_cedulaController.text}'),
                Text('Nombres: ${_nombresController.text}'),
                Text('Apellidos: ${_apellidosController.text}'),
                Text('Fecha Nacimiento: ${_fechaNacimientoController.text}'),
                Text('Edad: ${_edadController.text}'),
                Text('Género: ${_genero == 'masculino' ? 'Masculino' : 'Femenino'}'),
                Text('Estado Civil: ${_estadoCivil.toUpperCase()}'),
                Text('Acepta términos: ${_aceptaTerminos ? 'Sí' : 'No'}'),
                Text('Recibir notificaciones: ${_recibirNotificaciones ? 'Sí' : 'No'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo Cédula
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su cédula';
                  }
                  if (value.length < 10) {
                    return 'La cédula debe tener al menos 10 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Nombres
              TextFormField(
                controller: _nombresController,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese sus nombres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Apellidos
              TextFormField(
                controller: _apellidosController,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese sus apellidos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Fecha de Nacimiento
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () => _seleccionarFecha(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione su fecha de nacimiento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Edad (autocalculado)
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Radio buttons para Género
              const Text('Género', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Radio<String>(
                    value: 'masculino',
                    groupValue: _genero,
                    onChanged: (value) {
                      setState(() {
                        _genero = value!;
                      });
                    },
                  ),
                  const Text('Masculino'),
                  Radio<String>(
                    value: 'femenino',
                    groupValue: _genero,
                    onChanged: (value) {
                      setState(() {
                        _genero = value!;
                      });
                    },
                  ),
                  const Text('Femenino'),
                ],
              ),
              const SizedBox(height: 16),

              // Dropdown para Estado Civil
              DropdownButtonFormField<String>(
                value: _estadoCivil,
                decoration: const InputDecoration(
                  labelText: 'Estado Civil',
                  border: OutlineInputBorder(),
                ),
                items: _estadosCiviles.map((estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado[0].toUpperCase() + estado.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _estadoCivil = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione su estado civil';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Checkbox para Términos y Condiciones
              Row(
                children: [
                  Checkbox(
                    value: _aceptaTerminos,
                    onChanged: (value) {
                      setState(() {
                        _aceptaTerminos = value!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text('Acepto los términos y condiciones'),
                  ),
                ],
              ),

              // Checkbox para Notificaciones
              Row(
                children: [
                  Checkbox(
                    value: _recibirNotificaciones,
                    onChanged: (value) {
                      setState(() {
                        _recibirNotificaciones = value!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text('Recibir notificaciones por correo'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Salir'),
                  ),
                  ElevatedButton(
                    onPressed: _enviarFormulario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Siguiente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateFormat {
  DateFormat(String s);

  String format(DateTime picked) {
    return '${picked.day}/${picked.month}/${picked.year}';
  }
}