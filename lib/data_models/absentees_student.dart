class AbsenteesStudents{
  final int studentID;
  final String studentName;
  final int studentPRN;

  const AbsenteesStudents({
    required this.studentID,
    required this.studentName,
    required this.studentPRN,
  });

  factory AbsenteesStudents.fromJson(Map<String,dynamic> json){
    return AbsenteesStudents(
        studentID: json["student_id"],
        studentName: json["student_name"],
        studentPRN: json["student_prn"]
    );
  }
}