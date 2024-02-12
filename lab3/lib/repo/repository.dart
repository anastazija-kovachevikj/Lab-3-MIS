import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/exam.dart';

class Repository{
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addExam(Exam exam) async {
    try {
      db.collection('exams').add({
        'subject': exam.subject,
        'timeExam': exam.timeExam,
        'duration': exam.duration
      });

    } catch (e) {
      print("Cant add user");
    }
  }

  Future<List<Exam>> getAllExams() async {
    List<Exam> exams = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection("exams").get();
    querySnapshot.docs.forEach((doc) {
      Exam exam = Exam.fromJson(doc.data());
      exams.add(exam);
    });
    return exams;
  }

  Future<List<Exam>> getAllExamsWithStudentId(String id) async {
    List<Exam> exams = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
          .collection("users")
          .doc(id)
          .collection("exams")
          .get();

      querySnapshot.docs.forEach((doc) {
        exams.add(Exam.fromJson(doc.data()));
      });
    } catch (e) {
      print("Cant fetch exams");
    }

    return exams;
  }

  Future<void> addUser(String email, String id) async {
    try {
      db.collection('users').doc(id).set({
        'email': email,
      });

      print("successfully added");
    } catch (e) {
      print("error adding user");
    }
  }


  Future<void> addExamToStudent(Exam exam, String id) async {
    try {

      DocumentReference userRef =
      db.collection("users").doc(id);

      await userRef.collection("exams").add(exam.toJson());

      print("Exam added to user with email $id successfully.");
    } catch (e) {
      print("Error adding exam to user: $e");
    }
  }


}