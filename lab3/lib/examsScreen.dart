import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3/main.dart';
import 'package:lab3/table_calendar/main.dart';
import 'dart:math';
import '../model/exam.dart';
import 'package:lab3/repo/repository.dart';

class ExamsScreen extends StatefulWidget {

  @override
  _ExamsScreenState createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  Repository repository = Repository();
  List<Exam> exams = [];

  List<Color> bgColors = [
    Color(0xffD1E0D7),
    Color(0xffDBE2E9),
    Color(0xffFFDFC8),
    Color(0xffEBE49A)
  ];

  @override
  void initState() {
    super.initState();
    fetchExams();
  }

  Future<void> fetchExams() async {
    List<Exam> fetchedExams = await repository.getAllExams();
    setState(() {
      exams = fetchedExams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: const Text(
          'Exam Schedules',
          style: TextStyle(fontSize: 20, color: Color(0xff427e7e)),
        ),
      ),
      body: GridView.builder(
        itemCount: exams.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              repository.addExamToStudent(exams[index], FirebaseAuth.instance.currentUser!.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'title',)),
              );
            },
            child: _buildExamItem(exams[index], index),
          );
        },
      ),
    );
  }

  Widget _buildExamItem(Exam exam, int index) {
    Color bgColor = bgColors[index % bgColors.length];
    return Card(
      elevation: 5,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.subject,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            Text('Time: ${exam.timeExam}'),
            SizedBox(height: 5),
            Text('Duration: ${exam.duration} min'),
          ],
        ),
      ),
    );
  }


}
