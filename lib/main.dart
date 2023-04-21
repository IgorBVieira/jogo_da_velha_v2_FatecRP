import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(
    const MyApp()); // Roda o aplicativo num todo (Main com arrow function)

class MyApp extends StatelessWidget {
  //Classe que cria o corpo do aplicativo
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Constroi o corpo do aplicativo
    return MaterialApp(
      title: 'Jogo da Velha',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GameScreen(), // Função que retorna toda a parte funcional
    );
  }
}

class GameScreen extends StatefulWidget {
  //classe instanciar a parte funcional
  const GameScreen({Key? key}) : super(key: key);

  @override
  GameScreenState createState() =>
      GameScreenState(); // cria um instacia para usar os estados do aplicativo
}

class GameScreenState extends State<GameScreen> {
  //CLasse
  List<List<String>> _matriz =
      List.generate(3, (_) => List.generate(3, (_) => ''));
  String _jogadorAtual = 'X';
  String _ganhador = '';

  void _facaMovimento(int linha, int coluna) {
    //Movimentos do jogador
    setState(() {
      if (_matriz[linha][coluna] == '') {
        _matriz[linha][coluna] = _jogadorAtual;
        if (_checarGanhador()) {
          _ganhador = _jogadorAtual;
        } else if (_checarEmpate()) {
          _ganhador = 'Empate';
        } else {
          _trocarJogador();
          _facaMovimentoAI();
        }
      }
    });
  }

  void _facaMovimentoAI() {
    //Movimentos da maquina
    bool movimento = false;
    while (!movimento) {
      int linha = Random().nextInt(3);
      int coluna = Random().nextInt(3);
      if (_matriz[linha][coluna] == '') {
        _matriz[linha][coluna] = 'O';
        movimento = true;
        if (_checarGanhador()) {
          _ganhador = 'Máquina';
        } else if (_checarEmpate()) {
          _ganhador = 'Empate';
        } else {
          _trocarJogador();
        }
      }
    }
  }

  bool _checarGanhador() {
    // Verifica as linhas
    for (int i = 0; i < 3; i++) {
      if (_matriz[i][0] == _jogadorAtual &&
          _matriz[i][1] == _jogadorAtual &&
          _matriz[i][2] == _jogadorAtual) {
        return true;
      }
    }

    // Verifica as colunas
    for (int i = 0; i < 3; i++) {
      if (_matriz[0][i] == _jogadorAtual &&
          _matriz[1][i] == _jogadorAtual &&
          _matriz[2][i] == _jogadorAtual) {
        return true;
      }
    }

    // Verifica as diagonais
    if (_matriz[0][0] == _jogadorAtual &&
        _matriz[1][1] == _jogadorAtual &&
        _matriz[2][2] == _jogadorAtual) {
      return true;
    }
    if (_matriz[0][2] == _jogadorAtual &&
        _matriz[1][1] == _jogadorAtual &&
        _matriz[2][0] == _jogadorAtual) {
      return true;
    }

    return false;
  }

  bool _checarEmpate() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_matriz[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }

  void _trocarJogador() {
    _jogadorAtual = _jogadorAtual == 'X' ? 'O' : 'X';
  }

  void _reiniciarJogo() {
    setState(() {
      _matriz = List.generate(3, (_) => List.generate(3, (_) => ''));
      _jogadorAtual = 'X';
      _ganhador = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _reiniciarJogo,
            child: const Text('Reiniciar jogo'),
          ),
          Text(
            _ganhador != ''
                ? '$_ganhador ganhou!'
                : 'Jogador atual: $_jogadorAtual',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                int linha = index ~/ 3;
                int coluna = index % 3;
                return GestureDetector(
                  onTap: () => _facaMovimento(linha, coluna),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(), color: Colors.green),
                    child: Center(
                      child: Text(
                        _matriz[linha][coluna],
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//TODO: O jogo precisa congelar ao ter um ganhador ou empate
//TODO: O jogo precisa estar responsivo
//TODO: O jogo está com o projeto muito bagunçado
