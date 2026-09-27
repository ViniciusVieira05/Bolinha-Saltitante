import 'package:flutter/material.dart';
import 'dart:async';
import 'tela_inicial.dart';

void main() {
    runApp(
      MaterialApp(
        home: TelaInicial(),
      ),
    );
}

class BolinhaSaltitante extends StatefulWidget {
  @override
  State<BolinhaSaltitante> createState() {
    return _BolinhaSaltitanteState();
  }
}
class _BolinhaSaltitanteState extends State<BolinhaSaltitante> {

  double posicaoY = 30;
  bool pulando = false;
  double posicaoObstaculo = -40;

  Timer? timer;
  Timer? timerPulo;
  double larguraTela = 0;

  Rect bola = Rect.zero;
  Rect obstaculo = Rect.zero;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      Duration(milliseconds: 30),
          (timer) {
            setState(() {
                posicaoObstaculo += 8;


                if (posicaoObstaculo > larguraTela) {
                  posicaoObstaculo = -40;
                }
              });

            verificarColisao();
            },
    );
  }

  void verificarColisao() {
    if (bola.overlaps(obstaculo) && !pulando && !gameOver) {
      timer?.cancel();
      setState(() {
        gameOver = true;
      });
    }
  }

  void jogarNovamente() {
    timer?.cancel();

    setState(() {
      posicaoY = 30;
      posicaoObstaculo = -40;
      pulando = false;
      gameOver = false;
    });

    timer = Timer.periodic(
      Duration(milliseconds: 30),
          (timer) {
        setState(() {
          posicaoObstaculo += 8;

          if (posicaoObstaculo > larguraTela) {
            posicaoObstaculo = -40;
          }
        });

        verificarColisao();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    larguraTela = MediaQuery.of(context).size.width;

    bola = Rect.fromLTWH(
      100,
      MediaQuery.of(context).size.height - posicaoY - 60,
      60,
      60,
    );

    obstaculo = Rect.fromLTWH(
      larguraTela - posicaoObstaculo - 40,
      MediaQuery.of(context).size.height - 30 - 60,
      40,
      60,
    );

    return MaterialApp(
        home: GestureDetector(
          onTap: () {
            if (pulando || gameOver) {
              return;
            }

            pulando = true;

            timerPulo = Timer.periodic(
              Duration(milliseconds: 20),
                  (timer) {
                setState(() {
                  posicaoY += 10;

                  if (posicaoY >= 300) {
                    posicaoY = 300;
                  }
                });

                if (posicaoY >= 300) {
                  timer.cancel();

                  timerPulo = Timer.periodic(
                    Duration(milliseconds: 20),
                        (timer) {
                      setState(() {
                        posicaoY -= 10;

                        if (posicaoY <= 30) {
                          posicaoY = 30;
                        }
                      });

                      if (posicaoY <= 30) {
                        timer.cancel();
                        pulando = false;
                      }
                    },
                  );
                }
              },
            );
          },
          child: Stack(
            children: [
              Container(
                color: Colors.black,
              ),

              Positioned(
                bottom: posicaoY,
                left: 100,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                ),
              ),

              Positioned(
                bottom: 30,
                right: posicaoObstaculo,
                child: Container(
                  width: 40,
                  height: 60,
                  color: Colors.red,
                ),
              ),

              if (gameOver)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'GAME OVER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 40),

                          GestureDetector(
                            onTap: jogarNovamente,
                            child: Text(
                              'JOGAR NOVAMENTE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          GestureDetector(
                            onTap: () {
                              timer?.cancel();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TelaInicial(),
                                ),
                              );
                            },
                            child: Text(
                              'INÍCIO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}