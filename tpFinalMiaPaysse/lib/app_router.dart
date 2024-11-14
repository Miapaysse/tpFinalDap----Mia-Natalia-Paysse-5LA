import 'package:clase18_4/presentation/Screens/home_screen.dart';
import 'package:clase18_4/presentation/Screens/Login_screen.dart';
import 'package:clase18_4/presentation/Screens/empleado_info.dart';
import 'package:clase18_4/presentation/Screens/empleado_form.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: '/new',
      name: 'Nuevo empleado',
      builder: (context, state) {
        return EmpleadoForm();
      },
    ),
    GoRoute(
      path: '/edit/:empleado_id',
      name: 'Editar empleado',
      builder: (context, state) {
        final empleadoId = state.pathParameters['empleado_id'] ?? '';
        return EmpleadoForm(empleadoId: empleadoId);
      },
    ),
    GoRoute(
      name: InfoempleadosScreen.name,
      path: '/info/:empleado_id',
      builder: (context, state) {
        final empleadoId = state.pathParameters['empleado_id'] ?? '';
        return InfoempleadosScreen(empleadoId: empleadoId);
      },
    ),
  ],
);
