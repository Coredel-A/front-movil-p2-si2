import 'package:aula_virtual/models/colegio/materia.dart';
import 'package:aula_virtual/providers/grades_provider.dart';
import 'package:aula_virtual/providers/usuarios/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import 'package:aula_virtual/providers/colegio/curso_provider.dart';
import 'package:aula_virtual/providers/usuarios/alumno_provider.dart';
import 'package:aula_virtual/providers/evaluaciones/evaluacion_provider.dart';
import 'package:aula_virtual/providers/evaluaciones/nota_evaluacion_provider.dart';
import 'package:aula_virtual/providers/usuarios/docente_provider.dart';
import 'package:aula_virtual/providers/colegio/materia_provider.dart';
//services
import 'services/api_service.dart';
//screens
import 'screens/alumno/student_home_screen.dart';
import 'screens/alumno/student_profile_screen.dart';
import 'screens/alumno/student_task_screen.dart';
import 'screens/alumno/student_grades_screen.dart';
import 'screens/alumno/student_attendance_screen.dart';

import 'screens/docentes/teacher_profile_screen.dart';
import 'screens/docentes/teacher_home_screen.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //agregar los providers
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<CursoProvider>(create: (_) => CursoProvider()),
        ChangeNotifierProvider(create: (_) => GradesProvider()),
        ChangeNotifierProvider<AlumnoProvider>(create: (_) => AlumnoProvider()),
        ChangeNotifierProvider<EvaluacionProvider>(create: (_) => EvaluacionProvider()),
        ChangeNotifierProvider<NotaEvaluacionProvider>(create: (_) => NotaEvaluacionProvider()),
        ChangeNotifierProvider<MateriaProvider>(create: (_) => MateriaProvider()),
        ChangeNotifierProvider<DocenteProvider>(create: (_) => DocenteProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginScreen(),//StudentHomeScreen(alumnoId: 44,),
//TeacherHomeScreen(docenteId: 1),//TestDatosScreen(),
        //aqui agregar las rutas
        routes: {},
      ),
    );
  }
}

class TestDatosScreen extends StatefulWidget {
  const TestDatosScreen({super.key});

  @override
  State<TestDatosScreen> createState() => _TestDatosScreenState();
}

class _TestDatosScreenState extends State<TestDatosScreen> {
  @override
  void initState() {
    super.initState();
    testGetMAteriaByDocente();
    testGetAlumno();
    testGetCurso();
  }
  Future<void> testGetMAteriaByDocente() async {
    final materiaProvider = Provider.of<MateriaProvider>(context, listen: false);
    await materiaProvider.fetchMateriasByDocente(1); // Cambia el ID según tus datos
    print('Materias de docente obtenidos: ${materiaProvider.currentMateria}');
  }

  Future<void> testGetAlumno() async {
    final alumnoProvider = Provider.of<AlumnoProvider>(context, listen: false);
    await alumnoProvider.getAlumnoById(1); // Cambia el ID según tus datos
    print('Alumno obtenido: ${alumnoProvider.currentAlumno}');
  }

  Future<void> testGetCurso() async {
    final cursoProvider = Provider.of<CursoProvider>(context, listen: false);
    await cursoProvider.fetchCursoById(1);
    print('Curso obtenido: ${cursoProvider.currentCurso}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Probando getAlumnoById...')),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
