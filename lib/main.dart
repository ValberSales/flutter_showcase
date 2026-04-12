import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Jogos de Tabuleiro',
      debugShowCheckedModeBanner: false,
      
      // 1. TEMA CLARO (Padrão)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light, // Força o esquema claro
        ),
        useMaterial3: true,
      ),

      // 2. TEMA ESCURO
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Mantém a mesma cor base (opcional)
          brightness: Brightness.dark,  // Força o esquema escuro
        ),
        useMaterial3: true,
      ),

      // 3. COMPORTAMENTO DO TEMA
      // ThemeMode.system diz para o app obedecer à configuração do celular/computador.
      // Você também poderia forçar ThemeMode.light ou ThemeMode.dark.
      themeMode: ThemeMode.system, 

      home: const HomeScreen(),
    );
  }
}