// nuevo_empleado_screen.dart
import 'package:clase18_4/entities/Empleado.dart';
import 'package:clase18_4/presentation/Screens/loading_screen.dart';
import 'package:clase18_4/providers/empleados_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmpleadoForm extends ConsumerStatefulWidget {
  static const name = 'addEmployee';

  final String? empleadoId;

  const EmpleadoForm({this.empleadoId, super.key});

  @override
  _EmpleadoFormState createState() => _EmpleadoFormState(); //estado q maneja esta pantalla
}

class _EmpleadoFormState extends ConsumerState<EmpleadoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _posterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final empleadosCollectionActivity = ref.read(empleadosCollectionProvider); //solo la leemos
    if (widget.empleadoId != null && empleadosCollectionActivity.hasValue) {
      final empleado = empleadosCollectionActivity.value![widget.empleadoId]!;
      _nombreController.text = empleado.nombre;
      _apellidoController.text = empleado.apellido;
      _areaController.text = empleado.area;
      _posterController.text = empleado.poster;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.empleadoId == null ? 'Añadir' : 'Editar'} Empleado',
        ),
      ),
      body: widget.empleadoId == null
          ? _empleadoForm(context)
          : switch (empleadosCollectionActivity) {
              AsyncData() => _empleadoForm(context), // tenemos data mostramos form con los datos del empleaod
              AsyncError(:final error) => Center(
                  child:
                      Text('Error al obtener los datos del empleado: $error'),
                ),
              _ => const Center(
                  child: CircularProgressIndicator(),
                ),
            },
    );
  }

  Padding _empleadoForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese un nombre' : null,
            ),
            TextFormField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese un apellido' : null,
            ),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Area'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese un area' : null,
            ),
            TextFormField(
              controller: _posterController,
              decoration: const InputDecoration(labelText: 'Foto'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese una foto' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async { //tarea asincronica 
                if (_formKey.currentState!.validate()) {
                  final newEmpleado = Empleado(
                      nombre: _nombreController.text,
                      apellido: _apellidoController.text,
                      area: _areaController.text,
                      poster: _posterController.text);
                  if (widget.empleadoId == null) {
                    await LoadingScreen.showLoadingScreen(
                      context,
                      ref
                          .read(empleadosCollectionProvider.notifier)
                          .createEmpleado(newEmpleado),
                    );
                  } else {
                    await LoadingScreen.showLoadingScreen(
                      context,
                      ref
                          .read(empleadosCollectionProvider.notifier)
                          .updateEmpleado(widget.empleadoId!, newEmpleado),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
              label: Text('Guardar Empleado', style: TextStyle(color: Color.fromRGBO(23, 45, 212, 1),),)
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _areaController.dispose();
    super.dispose();
  }
}
