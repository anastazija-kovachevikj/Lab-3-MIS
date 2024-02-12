import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  String subject;
  DateTime timeExam;
  int duration;


  Exam({
    required this.subject,
    required this.timeExam,
    required this.duration,

  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      subject: json['subject'] as String,
      timeExam: DateParser(json['dateFrom']),
      duration: json['duration'] as int
    );
  }

  static DateTime DateParser(dynamic dateString) {
    if (dateString is String) {
      return DateTime.tryParse(dateString) ?? DateTime.now();
    } else if (dateString is Timestamp) {
      return dateString.toDate();
    } else {
      return DateTime.now();
    }
  }

  @override
  String toString() {
    return 'Exam{subject: $subject, dateFrom: $timeExam, duration : $duration}';
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'timeExam': timeExam.toIso8601String(),
      'duration' : duration
    };
  }


}