import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Menu/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gxuufblyfjwpthplrwly.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4dXVmYmx5Zmp3cHRocGxyd2x5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQyNDg5NzQsImV4cCI6MTk5OTgyNDk3NH0.tqpUczldBwD9RwsRyHqx25aKBzlrDS9De0XlqgqkACQ',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 89, 1, 242)),
        useMaterial3: true,
      ),
      home: const DashBoard(),
     // const MyWidget(),
    );
  }
}
