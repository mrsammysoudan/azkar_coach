import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MorningAzkarPage extends StatefulWidget {
  @override
  _MorningAzkarPageState createState() => _MorningAzkarPageState();
}

class _MorningAzkarPageState extends State<MorningAzkarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, String>> azkar = [
    {
      'title': 'الحماية من الجن',
      'description':
          'من قالها حين يصبح أجير من الجن حتى يمسى ومن قالها حين يمسى أجير من الجن حتى يصبح.',
      'image': 'assets/devil.png'
    },
    {
      'title': 'الحماية الكافية',
      'description':
          'من قالها حين يصبح وحين يمسى كفته من كل شىء (الإخلاص والمعوذتين).',
      'image': 'assets/shield.png'
    },
    {
      'title': 'الحرية من النار',
      'description': 'من قالها أعتقه الله من النار.',
      'image': 'assets/farfromhell.png'
    },
    {
      'title': 'شكر النعم',
      'description': 'من قالها حين يصبح أدى شكر يومه.',
      'image': 'assets/furfilled.png'
    },
    {
      'title': 'كفاية الله',
      'description': 'من قالها كفاه الله ما أهمه من أمر الدنيا والأخرة.',
      'image': 'assets/level5.png'
    },
    {
      'title': 'رضا الله',
      'description':
          'من قالها حين يصبح وحين يمسى كان حقا على الله أن يرضيه يوم القيامة.',
      'image': 'assets/level6.png'
    },
    {
      'title': 'الاعتراف بالنعم',
      'description':
          'اللهم ما أصبح بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك فلك الحمد ولك الشكر.',
      'image': 'assets/level7.png'
    },
    {
      'title': 'العافية في الجسد',
      'description':
          'اللهم عافني في بدني، اللهم عافني في سمعي، اللهم عافني في بصري، لا إله إلا أنت.',
      'image': 'assets/level8.png'
    },
    {
      'title': 'العفو والعافية',
      'description': 'اللهم إني أسألك العفو والعافية في الدنيا والآخرة.',
      'image': 'assets/level9.png'
    },
    {
      'title': 'الصلاة على النبي',
      'description': 'من صلى على حين يصبح وحين يمسى ادركته شفاعتى يوم القيامة.',
      'image': 'assets/level10.png'
    },
    {
      'title': 'الاستغفار',
      'description':
          'أسْتَغْفِرُ اللهَ العَظِيمَ الَّذِي لاَ إلَهَ إلاَّ هُوَ، الحَيُّ القَيُّومُ، وَأتُوبُ إلَيهِ.',
      'image': 'assets/level11.png'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF26134B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A148C), Color(0xFF260B53)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 1.28,
                      child: Lottie.asset(
                        'assets/background.json',
                        controller: _controller,
                        fit: BoxFit.cover,
                        repeat: false,
                        animate: true,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Azkar Coach',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/level1.png'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Level 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                itemCount: azkar.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[200]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(azkar[index]['image']!),
                            radius: 30,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  azkar[index]['title']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  azkar[index]['description']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
