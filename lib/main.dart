import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(FlashcardApp());
}

class Flashcard {
  String question;
  String answer;
  Flashcard({required this.question, required this.answer});
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reasoning Flashcards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: Colors.deepPurpleAccent,
          background: Color(0xFFF5F6FA),
        ),
        scaffoldBackgroundColor: Color(0xFFF5F6FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 20, color: Colors.indigo[900]),
        ),
        useMaterial3: true,
      ),
      home: FlashcardHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage>
    with SingleTickerProviderStateMixin {
  List<Flashcard> _flashcards = [
    Flashcard(
      question: "What comes next in the sequence: 2, 4, 8, 16, ...?",
      answer: "32 (Each number is multiplied by 2)",
    ),
    Flashcard(
      question:
          "If all Bloops are Razzies and all Razzies are Lazzies, are all Bloops definitely Lazzies?",
      answer: "Yes (Syllogism)",
    ),
    Flashcard(
      question: "Find the odd one out: Apple, Banana, Carrot, Mango",
      answer: "Carrot (It's a vegetable, others are fruits)",
    ),
    Flashcard(
      question: "If CAT is coded as 3120, how is DOG coded?",
      answer: "4157 (Assign numbers to letters: D=4, O=15, G=7)",
    ),
    Flashcard(
      question:
          "Which number should replace the question mark? 3, 6, 11, 18, ?",
      answer: "27 (Add consecutive odd numbers: +3, +5, +7, +9...)",
    ),
    Flashcard(
      question: "A is taller than B, B is taller than C. Who is the shortest?",
      answer: "C",
    ),
    Flashcard(
      question:
          "If you rearrange the letters 'CIFAIPC', you get the name of a(n):",
      answer: "PACIFIC (Ocean)",
    ),
    Flashcard(
      question:
          "Which word does NOT belong: Triangle, Square, Circle, Rectangle?",
      answer: "Circle (It has no sides)",
    ),
    Flashcard(
      question: "What is the next number in the pattern: 1, 4, 9, 16, ...?",
      answer: "25 (Perfect squares: 1^2, 2^2, 3^2, 4^2, ...)",
    ),
    Flashcard(
      question: "If 5 pencils cost \$10, how much do 8 pencils cost?",
      answer: "\$16 (Each pencil costs \$2)",
    ),
  ];

  int _currentIndex = 0;
  bool _showFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
      _resetFlip();
    });
  }

  void _prevCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _flashcards.length) % _flashcards.length;
      _resetFlip();
    });
  }

  void _resetFlip() {
    _controller.reverse();
    _showFront = true;
  }

  void _addFlashcard() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Question')),
            TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (questionController.text.trim().isNotEmpty &&
                  answerController.text.trim().isNotEmpty) {
                setState(() {
                  _flashcards.add(Flashcard(
                    question: questionController.text.trim(),
                    answer: answerController.text.trim(),
                  ));
                  _currentIndex = _flashcards.length - 1;
                  _resetFlip();
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editFlashcard(int index) {
    TextEditingController questionController =
        TextEditingController(text: _flashcards[index].question);
    TextEditingController answerController =
        TextEditingController(text: _flashcards[index].answer);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Question')),
            TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (questionController.text.trim().isNotEmpty &&
                  answerController.text.trim().isNotEmpty) {
                setState(() {
                  _flashcards[index] = Flashcard(
                    question: questionController.text.trim(),
                    answer: answerController.text.trim(),
                  );
                  _resetFlip();
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteFlashcard(int index) {
    if (_flashcards.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot delete the last flashcard!')),
      );
      return;
    }
    setState(() {
      _flashcards.removeAt(index);
      _currentIndex = _currentIndex % _flashcards.length;
      _resetFlip();
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcard = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Reasoning Flashcards'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 36),
              GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double angle = _animation.value * pi;
                    bool isFront = angle <= (pi / 2);
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: isFront
                          ? _buildFlashcardSide(flashcard.question, context)
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(pi),
                              child: _buildFlashcardSide(
                                  flashcard.answer, context,
                                  isAnswer: true),
                            ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[400],
                      foregroundColor: Colors.white,
                      minimumSize: Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    label: Text("Previous"),
                    onPressed: _prevCard,
                  ),
                  SizedBox(width: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      minimumSize: Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    label: Text("Next"),
                    onPressed: _nextCard,
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.indigo, size: 32),
              tooltip: "Add",
              onPressed: _addFlashcard,
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.deepPurpleAccent, size: 32),
              tooltip: "Edit",
              onPressed: () => _editFlashcard(_currentIndex),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent, size: 32),
              tooltip: "Delete",
              onPressed: () => _deleteFlashcard(_currentIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardSide(String text, BuildContext context,
      {bool isAnswer = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 220,
      decoration: BoxDecoration(
        color: isAnswer ? Colors.deepPurple[50] : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.18),
            blurRadius: 24,
            spreadRadius: 4,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(30),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          color: isAnswer ? Colors.deepPurple[700] : Colors.indigo[900],
          fontWeight: isAnswer ? FontWeight.bold : FontWeight.w500,
          letterSpacing: 0.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}