class TeacherSubjects{
  final int id;
  final String subjectCode;
  final String subjectName;
  final int strength;

  const TeacherSubjects({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.strength
  });

  factory TeacherSubjects.fromJson(Map<String,dynamic> json){
    return TeacherSubjects(
      id: json['id'],
      subjectCode: json['code'],
      subjectName: json['name'],
      strength: json['strength'],
    );
  }
}