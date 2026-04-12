import 'package:flutter/material.dart';
import '../repositories/jogo_repository.dart';
import 'details_screen.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final jogos = JogoRepository.jogos;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Meus Jogos de Tabuleiro'),
        actions: [
          // Botão de informação que abre os detalhes da licença
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sobre o App',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'CRUD Jogos',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 40),
                applicationLegalese: '© 2026 Valber Sales Junior\nDistribuído sob a licença BSD 3-Clause.',
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Este é um projeto de código aberto desenvolvido como exemplo prático '
                          'de um CRUD utilizando boas práticas de componentização em Flutter.',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: jogos.isEmpty
          ? const Center(child: Text('Nenhum jogo cadastrado. Adicione um!'))
          : ListView.builder( // 1. Mudamos de 'separated' para 'builder'
              padding: const EdgeInsets.all(8),
              itemCount: jogos.length,
              itemBuilder: (context, index) {
                final jogo = jogos[index];
                
                // 2. Envolvemos o ListTile com um Card
                return Card(
                  elevation: 4, // Controla o tamanho da sombra do card
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4), // Espaçamento externo
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Deixa as bordas arredondadas
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.casino_rounded),
                    ),
                    title: Text(
                      jogo.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${jogo.editora} • ${jogo.ano}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      // Vai para a tela de detalhes e aguarda o retorno
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(jogoId: jogo.id),
                        ),
                      );
                      _refresh(); // Atualiza a lista ao voltar
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
          _refresh();
        },
        tooltip: 'Adicionar Jogo',
        child: const Icon(Icons.add),
      ),
    );
  }
}