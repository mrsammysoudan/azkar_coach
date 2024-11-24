import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SpeechToTextApp(),
    );
  }
}

class SpeechToTextApp extends StatefulWidget {
  @override
  _SpeechToTextAppState createState() => _SpeechToTextAppState();
}

class _SpeechToTextAppState extends State<SpeechToTextApp> {
  late stt.SpeechToText _speech;
  late AudioPlayer _audioPlayer;
  late StreamSubscription _positionSubscription;
  bool _isListening = false;
  String _text = 'سبحان الله والحمد لله ولا إله إلا الله والله أكبر';
  String _spokenText = '';
  String _feedback = '';
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _audioPlayer = AudioPlayer();
    _positionSubscription = _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _audioPosition = p;
      });
    });
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _audioDuration = d;
      });
    });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    super.dispose();
  }

  void _initializeSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (!available) {
      print('Speech recognition not available');
    }
  }

  Future<void> _playAudio(String fileName) async {
    await _audioPlayer.play(AssetSource('audio/$fileName'));
  }

  void _listen() async {
    if (await Permission.microphone.request().isGranted) {
      if (!_isListening) {
        bool available = await _speech.initialize(
          onStatus: (val) {
            setState(() {
              _isListening = val == 'listening';
            });
            print('onStatus: $val');
          },
          onError: (val) {
            setState(() {
              _isListening = false;
            });
            print('onError: $val');
          },
        );
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) => setState(() {
              _spokenText = val.recognizedWords;
              _isListening = false;
              _compareText();
            }),
            localeId: 'ar_SA', // Arabic locale
          );
        }
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    } else {
      print('Microphone permission denied');
    }
  }

  void _compareText() {
    // Normalize text by removing diacritics and punctuation
    String normalizedText = _normalizeText(_text);
    String normalizedSpokenText = _normalizeText(_spokenText);

    if (normalizedText == normalizedSpokenText) {
      setState(() {
        _feedback = 'Matched';
      });
    } else {
      setState(() {
        _feedback = 'Not Matched';
      });
    }
  }

  String _normalizeText(String text) {
    // Remove diacritics
    text = text.replaceAll(RegExp(r'[\u064B-\u0652]'), '');
    // Remove punctuation
    text = text.replaceAll(RegExp(r'[^\w\s]'), '');
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1E68), Color(0xFF26134B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.close, color: Colors.white),
                        Icon(Icons.lightbulb_outline, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        _listen();
                      },
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _isListening ? 'Listening...' : 'Tap the mic',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(24), // Increase padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[200]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.play_circle_fill,
                                    color: Colors.orange, size: 40),
                                onPressed: () async {
                                  await _playAudio('audio1.mp3');
                                },
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: CustomWaveform(
                                  duration: _audioDuration,
                                  position: _audioPosition,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Increase space between rows
                          Text(
                            _text,
                            style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'Amiri'), // Increase font size
                          ),
                          SizedBox(height: 20), // Increase space between text
                          Text(
                            _spokenText,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 24), // Increase font size
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.speed, color: Colors.orange),
                              Icon(Icons.bookmark_border, color: Colors.grey),
                              Icon(Icons.text_fields, color: Colors.green),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A2A7A), Color(0xFF26134B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/level1.png',
                                width: 150, height: 150),
                            SizedBox(width: 0),
                            Text(
                              'Level 1',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          '58%',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Current XP: 1234',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomWaveform extends StatelessWidget {
  final Duration duration;
  final Duration position;

  const CustomWaveform({
    Key? key,
    required this.duration,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0;

    final heights = [
      15.0,
      25.0,
      10.0,
      30.0,
      20.0,
      35.0,
      15.0,
      20.0,
      10.0,
      25.0,
      20.0,
      30.0,
      10.0,
      25.0,
      15.0,
      35.0,
      20.0,
      10.0,
      30.0,
      25.0,
      15.0,
      20.0,
      35.0,
      10.0,
      25.0
    ];

    String formatDuration(Duration d) {
      String minutes = d.inMinutes.toString().padLeft(2, '0');
      String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(heights.length, (index) {
                    return Expanded(
                      child: Container(
                        height: heights[index],
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        color: index / heights.length <= progress
                            ? Colors.orange
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(
              width: 10), // Add some space between the waveform and the label
          Text(
            formatDuration(position),
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
