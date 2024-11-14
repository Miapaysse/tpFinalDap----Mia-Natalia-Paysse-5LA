import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/entities/Empleado.dart';

part 'empleados_collection.g.dart';

@riverpod
class EmpleadosCollection extends _$EmpleadosCollection {
  static final CollectionReference _empleadosCollection = FirebaseFirestore.instance.collection('empleados');

  static Future<Map<String, Empleado>> getAllEmpleados() async {
    final snapshot = await _empleadosCollection.get();
    return Map.fromEntries(snapshot.docs
        .map((doc) => MapEntry(doc.id, Empleado.fromFirestore(doc.data() as Map<String, dynamic>))));
  }

  Future<void> createEmpleado(Empleado empleado) async {
    await _empleadosCollection.doc().set(empleado.toMap());
    ref.invalidateSelf();
  }

  Future<void> updateEmpleado(String id, Empleado empleado) async {
    await _empleadosCollection
        .doc(id)
        .update(empleado.toMap());
    ref.invalidateSelf();

    
  }
  Future<void> deleteEmpleado(String id) async {
    await _empleadosCollection.doc(id).delete();
    ref.invalidateSelf();
  }

  FutureOr<Map<String, Empleado>> build() async {
    return await getAllEmpleados();
  }
}
