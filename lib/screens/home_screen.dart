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
      ),
      body: jogos.isEmpty
          ? const Center(child: Text('Nenhum jogo cadastrado. Adicione um!'))
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: jogos.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final jogo = jogos[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.casino),
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