import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab3/firebase_options.dart';
import 'package:lab3/loginPage.dart';
import 'package:lab3/registerPage.dart'; // Import Firebase Core
import 'package:lab3/authentication/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3/repo/repository.dart';

import 'examsScreen.dart';
import 'model/exam.dart';

void main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyCYod-Gg3IdcnXXMxR6p8iYqVIT22BRxW8",
  //     appId: "1:592823284758:android:0477b5cf483f9349d8f137",
  //     messagingSenderId: "592823284758",
  //     projectId: "mislabs123890",
  //   ),
  // );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  Repository repository = new Repository();
  // Exam exam1 = Exam(
  //   subject: "Introduction to Computer Science",
  //   timeExam: DateTime(2024, 3, 19,10,0),
  //   duration: 120
  // );
  // Exam exam4 = Exam(
  //   subject: "Web Programming",
  //   timeExam: DateTime(2024, 3, 17,19,0),
  //   duration: 180
  // );
  // Exam exam3 = Exam(
  //   subject: "Compilers",
  //   timeExam: DateTime(2024, 3, 20,8,0),
  //   duration: 180
  // );
  // Exam exam2 = Exam(
  //   subject: "Computer ethics",
  //   timeExam: DateTime(2024, 3, 23,12,0),
  //   duration: 30
  // );
  // Exam exam5 = Exam(
  //   subject: "Web based systems",
  //   timeExam: DateTime(2024, 3, 10,11,0),
  //   duration: 60
  // );
  // Exam exam6 = Exam(
  //     subject: "Introduction to data science",
  //     timeExam: DateTime(2024, 3, 19,15,0),
  //     duration: 60
  // );
  // Exam exam7 = Exam(
  //     subject: "Mobile information systems",
  //     timeExam: DateTime(2024, 3, 18,13,0),
  //     duration: 90
  // );
  // Exam exam8 = Exam(
  //     subject: "Introduction to web design",
  //     timeExam: DateTime(2024, 3, 15,17,0),
  //     duration: 60
  // );
  //
  // await repository.addExam(exam1);
  // await repository.addExam(exam2);
  // await repository.addExam(exam3);
  // await repository.addExam(exam4);
  // await repository.addExam(exam5);
  // await repository.addExam(exam6);
  // await repository.addExam(exam7);
  // await repository.addExam(exam8);

  // try {
  //   final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //     email: "anastazijakovacevic@gmail.com",
  //     password: "_123Astor",
  //   );
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'weak-password') {
  //     print('The password provided is too weak.');
  //   } else if (e.code == 'email-already-in-use') {
  //     print('The account already exists for that email.');
  //   }
  // } catch (e) {
  //   print(e);
  // }




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff427e7e)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(title: 'Lab3 - Index : 203060',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Repository repository = Repository();
  List<Exam> userExams = [];

  @override
  void initState() {
    super.initState();
    fetchUserExams();
  }

  Future<void> fetchUserExams() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      List<Exam> exams = await repository.getAllExamsWithStudentId(userId);
      setState(() {
        userExams = exams;
      });
    }
  }@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff427e7e),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            child: IconButton(
              icon: Icon(Icons.add_circle_outlined, color: Colors.white),
              onPressed: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExamsScreen()),
                  ).then((_) {
                    fetchUserExams(); // Refresh when navigating back
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to perform action.'),
                    ),
                  );
                }
                // Handle add action
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            child: IconButton(
              icon: Icon(Icons.account_circle_sharp, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have been logged out.'),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You are not currently logged in.'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: userExams.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return _buildExamItem(userExams[index]);
        },
      ),
    );
  }

  Widget _buildExamItem(Exam exam) {
    return Card(
      elevation: 5,
      color: Color(0xffFADDE1),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
