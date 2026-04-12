import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../repositories/jogo_repository.dart';

class FormScreen extends StatefulWidget {
  final String? jogoId; 

  const FormScreen({super.key, this.jogoId});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeCtrl = TextEditingController();
  final _editoraCtrl = TextEditingController();
  final _anoCtrl = TextEditingController();
  final _minJogadoresCtrl = TextEditingController();
  final _maxJogadoresCtrl = TextEditingController();

  bool get isEdicao => widget.jogoId != null;

  @override
  void initState() {
    super.initState();
    if (isEdicao) {
      final jogo = JogoRepository.jogos.firstWhere((j) => j.id == widget.jogoId);
      _nomeCtrl.text = jogo.nome;
      _editoraCtrl.text = jogo.editora;
      _anoCtrl.text = jogo.ano.toString();
      _minJogadoresCtrl.text = jogo.minJogadores.toString();
      _maxJogadoresCtrl.text = jogo.maxJogadores.toString();
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _editoraCtrl.dispose();
    _anoCtrl.dispose();
    _minJogadoresCtrl.dispose();
    _maxJogadoresCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      if (isEdicao) {
        final jogo = JogoRepository.jogos.firstWhere((j) => j.id == widget.jogoId);
        jogo.nome = _nomeCtrl.text;
        jogo.editora = _editoraCtrl.text;
        jogo.ano = int.parse(_anoCtrl.text);
        jogo.minJogadores = int.parse(_minJogadoresCtrl.text);
        jogo.maxJogadores = int.parse(_maxJogadoresCtrl.text);
      } else {
        final novoJogo = Jogo(
          id: DateTime.now().millisecondsSinceEpoch.toString(), 
          nome: _nomeCtrl.text,
          editora: _editoraCtrl.text,
          ano: int.parse(_anoCtrl.text),
          minJogadores: int.parse(_minJogadoresCtrl.text),
          maxJogadores: int.parse(_maxJogadoresCtrl.text),
        );
        JogoRepository.jogos.add(novoJogo);
      }
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(isEdicao ? 'Editar Jogo' : 'Novo Jogo'),
      ),
      // Center e SingleChildScrollView trabalham juntos para centralizar e permitir rolagem
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          // ConstrainedBox limita a largura do formulário para 450 pixels
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0), // Respiro interno do form
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Faz a coluna abraçar o conteúdo sem esticar até o fim da tela
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nomeCtrl,
                        decoration: const InputDecoration(labelText: 'Nome do Jogo', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _editoraCtrl,
                        decoration: const InputDecoration(labelText: 'Editora', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _anoCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Ano de Lançamento', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _minJogadoresCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Mín. Jogadores', border: OutlineInputBorder()),
                              validator: (value) => value!.isEmpty ? '*' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _maxJogadoresCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Máx. Jogadores', border: OutlineInputBorder()),
                              validator: (value) => value!.isEmpty ? '*' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _salvar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(isEdicao ? 'Salvar Alterações' : 'Cadastrar Jogo', style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}