import 'package:clase18_4/app_router.dart';
import 'package:clase18_4/entities/Empleado.dart';
import 'package:clase18_4/presentation/Screens/loading_screen.dart';
import 'package:clase18_4/providers/empleados_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoempleadosScreen extends ConsumerStatefulWidget {
  static const name = 'InfoEmpleadosScreen';
  const InfoempleadosScreen({super.key, required this.empleadoId});

  final String empleadoId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InfoempleadosScreenState();
}

class _InfoempleadosScreenState extends ConsumerState<InfoempleadosScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final empleadosCollectionActivity = ref.watch(empleadosCollectionProvider);

    String? empleadoId = empleadosCollectionActivity.asData?.valueOrNull?.keys
        .firstWhere((id) => id == widget.empleadoId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de empleado'),
      ),
      body: switch (empleadosCollectionActivity) {
        AsyncData(value: final empleadosCollection) => empleadoId == null ||
                empleadosCollection.containsKey(empleadoId) == false
            ? Center(
                child: Text('Empleado no encontrado'),
              )
            : _InfoempleadosScreen(
                empleado: empleadosCollection[widget.empleadoId]!,
                onDelete: () async {
                  await LoadingScreen.showLoadingScreen(
                    context,
                    ref
                        .read(empleadosCollectionProvider.notifier)
                        .deleteEmpleado(widget.empleadoId),
                  );
                  appRouter.pop();
                },
                onEditTap: () {
                  appRouter.push('/edit/$empleadoId');
                },
              ),
        AsyncError(:final error) => Center(
            child: Text('Error al obtener los empleados: $error'),
          ),
        _ => const Center(
            child: CircularProgressIndicator(),
          ),
      },
    );
  }
}

class _InfoempleadosScreen extends StatelessWidget {
  const _InfoempleadosScreen({
    required this.empleado,
    required this.onDelete,
    required this.onEditTap,
  });

  final Empleado empleado;
  final Future<void> Function() onDelete;
  final void Function() onEditTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(empleado.poster, height: 300),
            const SizedBox(height: 16),
            Text(
              'Nombre: ${empleado.nombre}',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
            ),
            Text(
              'Apellido: ${empleado.apellido}',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
            ),
            Text(
              'Area: ${empleado.area}',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
            ),
            const SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await onDelete();
                    // Call the delete callback when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    iconColor: Color.fromRGBO(23, 45, 212, 1),
                  ),
                  label: Text('Eliminar', style: TextStyle(color: Color.fromRGBO(23, 45, 212, 1)),),
                  icon: Icon(Icons.delete),
                ),
                ElevatedButton.icon(
                  onPressed: onEditTap,
                  style:ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  iconColor: Color.fromRGBO(23, 45, 212, 1),
                  ),
                  label: Text('Editar', style: TextStyle(color:Color.fromRGBO(23, 45, 212, 1) ),),
                  icon: Icon(Icons.edit, color: Color.fromRGBO(23, 45, 212, 1),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
