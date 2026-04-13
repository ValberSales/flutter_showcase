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

  // ============================================================================
  // 🧠 BLOCO DE LÓGICA E ESTADO DA TELA
  // Aqui são definidas variáveis, controladores, validações e o ciclo de vida.
  // É o "cérebro" da tela, onde os dados são processados antes de serem exibidos.
  // ============================================================================

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


  // ============================================================================
  // 🎨 BLOCO DE CONSTRUÇÃO DA INTERFACE (UI)
  // O método "build" é onde o Flutter começa a desenhar a tela de fato.
  // Tudo que retorna daqui é o que o usuário vai enxergar.
  // ============================================================================

  @override
  Widget build(BuildContext context) {

    // INÍCIO: SCAFFOLD (O esqueleto principal da tela)
    return Scaffold(

      // INÍCIO: APP BAR (A barra superior)
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(isEdicao ? 'Editar Jogo' : 'Novo Jogo'),
      ),
      // FIM: APP BAR

      // INÍCIO: CENTER (Centraliza tudo no meio da tela)
      body: Center(

        // INÍCIO: SINGLE CHILD SCROLL VIEW (Permite rolar a tela se o teclado abrir)
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),

          // INÍCIO: CONSTRAINED BOX (Trava a largura máxima)
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),

            // INÍCIO: CARD (A caixa branca com sombra)
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              // INÍCIO: PADDING (Espaço interno do Card)
              child: Padding(
                padding: const EdgeInsets.all(24.0),

                // INÍCIO: FORM (O formulário que agrupa os campos)
                child: Form(
                  key: _formKey,

                  // INÍCIO: COLUMN (Empilha os campos de cima para baixo)
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      // INÍCIO: CAMPO 1 (Nome)
                      TextFormField(
                        controller: _nomeCtrl,
                        decoration: const InputDecoration(labelText: 'Nome do Jogo', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      // FIM: CAMPO 1

                      const SizedBox(height: 16),

                      // INÍCIO: CAMPO 2 (Editora)
                      TextFormField(
                        controller: _editoraCtrl,
                        decoration: const InputDecoration(labelText: 'Editora', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      // FIM: CAMPO 2

                      const SizedBox(height: 16),

                      // INÍCIO: CAMPO 3 (Ano)
                      TextFormField(
                        controller: _anoCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Ano de Lançamento', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      // FIM: CAMPO 3

                      const SizedBox(height: 16),

                      // INÍCIO: ROW (Coloca os campos de jogadores lado a lado)
                      Row(
                        children: [

                          // INÍCIO: METADE ESQUERDA (Mín. Jogadores)
                          Expanded(
                            child: TextFormField(
                              controller: _minJogadoresCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Mín. Jogadores', border: OutlineInputBorder()),
                              validator: (value) => value!.isEmpty ? '*' : null,
                            ),
                          ),
                          // FIM: METADE ESQUERDA

                          const SizedBox(width: 16),

                          // INÍCIO: METADE DIREITA (Máx. Jogadores)
                          Expanded(
                            child: TextFormField(
                              controller: _maxJogadoresCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Máx. Jogadores', border: OutlineInputBorder()),
                              validator: (value) => value!.isEmpty ? '*' : null,
                            ),
                          ),
                          // FIM: METADE DIREITA

                        ],
                      ),
                      // FIM: ROW

                      const SizedBox(height: 32),

                      // INÍCIO: BOTÃO SALVAR
                      ElevatedButton(
                        onPressed: _salvar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(isEdicao ? 'Salvar Alterações' : 'Cadastrar Jogo', style: const TextStyle(fontSize: 16)),
                      ),
                      // FIM: BOTÃO SALVAR

                    ],
                  ),
                  // FIM: COLUMN
                ),
                // FIM: FORM
              ),
              // FIM: PADDING
            ),
            // FIM: CARD
          ),
          // FIM: CONSTRAINED BOX
        ),
        // FIM: SINGLE CHILD SCROLL VIEW
      ),
      // FIM: CENTER
    );
    // FIM: SCAFFOLD
  }
}