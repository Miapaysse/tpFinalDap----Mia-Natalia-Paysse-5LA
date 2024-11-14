import 'package:clase18_4/entities/Empleado.dart';
import 'package:flutter/material.dart';


class EmpleadoItem extends StatelessWidget {
  const EmpleadoItem({
    super.key,
    required this.empleado,
    this.onTap, 
    required this.backgroundColor,
    required this.text1Color,
    required this.text2Color,
    required this.arrowColor,
    required this.hoverColor,
  });

  final Empleado empleado;
  final Color backgroundColor;
  final Color text1Color;
  final Color text2Color;
  final Color arrowColor;
  final Color hoverColor;
  final Function? onTap;


 @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: empleado.poster != null
            ? _getPoster(empleado.poster)
            : const Icon(Icons.emoji_people),
        title: Text("${empleado.nombre} ${empleado.apellido}", style: TextStyle(color: text1Color),),
        subtitle: Text('Area de trabajo: ${empleado.area}', style: TextStyle(color: text2Color),),
        trailing: Icon(Icons.arrow_forward_ios, color: arrowColor),
        tileColor: backgroundColor,
        hoverColor: hoverColor,
        onTap: () => onTap?.call(),
      ),
    );
  }

  Widget _getPoster(String posterUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(posterUrl, width: 60,),
    );
  }
}