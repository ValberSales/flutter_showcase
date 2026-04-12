import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../repositories/jogo_repository.dart';
import 'form_screen.dart';

class DetailsScreen extends StatefulWidget {
  final String jogoId;

  const DetailsScreen({super.key, required this.jogoId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Jogo _jogo;

  @override
  void initState() {
    super.initState();
    _carregarJogo();
  }

  void _carregarJogo() {
    _jogo = JogoRepository.jogos.firstWhere((j) => j.id == widget.jogoId);
  }

  void _apagarJogo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar Jogo?'),
        content: Text('Tem certeza que deseja apagar "${_jogo.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              JogoRepository.jogos.removeWhere((j) => j.id == _jogo.id);
              Navigator.pop(context); // Fecha o dialog
              Navigator.pop(context); // Volta para a tela inicial
            },
            child: const Text('Apagar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detalhes do Jogo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          // Card para limitar sua largura máxima
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450), // Largura ideal para leitura
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome', style: Theme.of(context).textTheme.labelLarge),
                    Text(_jogo.nome, style: Theme.of(context).textTheme.headlineMedium),
                    const Divider(height: 32),
                    
                    _buildDetailRow('Editora:', _jogo.editora),
                    _buildDetailRow('Ano de Lançamento:', _jogo.ano.toString()),
                    _buildDetailRow('Mín. Jogadores:', _jogo.minJogadores.toString()),
                    _buildDetailRow('Máx. Jogadores:', _jogo.maxJogadores.toString()),
                    
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormScreen(jogoId: _jogo.id),
                              ),
                            );
                            setState(() {
                              _carregarJogo();
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text('Apagar', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                          ),
                          onPressed: _apagarJogo,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 8),
          Expanded( // Impede que textos muito grandes quebrem o layout
            child: Text(
              value, 
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}