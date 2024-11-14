import 'package:clase18_4/entities/Empleado.dart';
import 'package:clase18_4/presentation/widgets/Empleado_item.dart';
import 'package:clase18_4/providers/empleados_collection.dart';
import 'package:clase18_4/presentation/Screens/empleado_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_router.dart';

class HomeScreen extends ConsumerStatefulWidget { //StatefullWidget porque la screen tiene un estado que puede variar en el tiempo, nosotros accedemos a los providers de riperpod para escuchar este estado y actualizar
  static const name = 'home';
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState(); //_HomeScreenState maneja el estado, es consumer porque asi puede acceder a los datos del empleados_collection provider que es el que interactua con firestore
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final empleadosCollectionActivity =
          ref.watch(empleadosCollectionProvider); // aca es donde interactuamos con el provider y con watch escuchamos los cambios lo igualamos a la activity

      return Scaffold(
        appBar: AppBar(
          title: const Text('Mis Empleados'),
        ),
        body: switch (empleadosCollectionActivity) { //los casos de la actividad 
          AsyncData(value: final empleadosCollection) => _HomeScreen( //tenemos data
              empleados: empleadosCollection,
              onRefresh: _onRefresh,
              onEmpleadoTap: (empleadoId) => _onEmpleadoTap(
                context,
                empleadoId,
              ),
            ),
          AsyncError(:final error) => Center( //tenemos un error :(
              child: Text('Error: $error'),
            ),
          _ => const CircularProgressIndicator(),
        },
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            appRouter.push( //nuevo empleadooo, vamos al foorm
              '/new'
            );
          },
          backgroundColor: Color.fromRGBO(6, 35, 201, 1),
          hoverColor: Color.fromRGBO(103, 116, 199, 1),
          child: const Icon(Icons.add, color: Color.fromRGBO(255, 255, 255, 1),), 
        ),
      );
    });
  }

  Future<void> _onRefresh() async {
    ref.invalidate(empleadosCollectionProvider); //se invalida todo lo anterior
  }

  void _onEmpleadoTap(BuildContext context, String empleadoId) { //nos vamos a ver en detalles
    appRouter.push('/info/$empleadoId');
  }
}

class _HomeScreen extends StatelessWidget {
  _HomeScreen({
    required this.empleados,
    required this.onRefresh,
    required this.onEmpleadoTap,
  });

  final Map<String, Empleado> empleados; // lista de empleados mapeada 
  final Future<void> Function() onRefresh;  //devuelve una promesa porque tarda en traer las cosas 
  final Function(String empleadoId) onEmpleadoTap; 


  @override
  Widget build(BuildContext context) {
    if (empleados.isEmpty) {
      return const Center(child: Text('No hay empleados.'));
    }

    final empleadoIds = empleados.keys.toList(); //transformamos el map en una lista

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: empleadoIds.length,
        itemBuilder: (context, index) {
          final empleadoId = empleadoIds[index];
          final empleado = empleados[empleadoId]!; // obtenemos los atributos del empleado a traves de su id 
          return EmpleadoItem( //metemos el empleado en el item que cree
            empleado: empleado,
            onTap: () => onEmpleadoTap(empleadoId),
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            text1Color:Color.fromRGBO(37, 54, 185, 1),
            text2Color:Color.fromRGBO(55, 70, 184, 1),
            arrowColor:Color.fromRGBO(37, 54, 185, 1),
            hoverColor: Color.fromRGBO(37, 54, 185, 0.352),
          );
        },
      ),
    );
  }
}
