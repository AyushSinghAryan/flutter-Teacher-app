import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_teacher_app/Pages/home_page.dart';
import 'package:flutter_teacher_app/Pages/login_page.dart';

import '../models/student_model.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({super.key});

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Student",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Data",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Navigate to login screen after logout
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs.map((doc) {
            return Student.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      "Name : ${student.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('DOB: ${student.dob} - Gender: ${student.gender}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editStudent(context, student),
                    ),
                    onLongPress: () =>
                        _confirmDeleteStudent(context, student.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddStudentForm(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddStudentForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _editStudent(BuildContext context, Student student) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomePage(student: student),
      ),
    );
  }

  void _confirmDeleteStudent(BuildContext context, String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteStudent(studentId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteStudent(String studentId) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student data deleted successfully')));
  }
}
