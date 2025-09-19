import 'package:flutter/material.dart';

@immutable
class Student {
  final String nisn;
  final String fullName;
  final String gender;
  final String religion;
  final String birthPlace;
  final String birthDate;
  final String phoneNumber;
  final String nik;
  final String street;
  final String rtRw;
  final String dusun;
  final String village;
  final String district;
  final String city;
  final String province;
  final String postalCode;
  final String fatherName;
  final String motherName;
  final String? guardianName; // Nullable karena boleh kosong
  final String studentAddress;
  final String parentAddress;

  Student({
    required this.nisn,
    required this.fullName,
    required this.gender,
    required this.religion,
    required this.birthPlace,
    required this.birthDate,
    required this.phoneNumber,
    required this.nik,
    required this.street,
    required this.rtRw,
    required this.dusun,
    required this.village,
    required this.district,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.fatherName,
    required this.motherName,
    this.guardianName,
    required this.studentAddress,
    required this.parentAddress,
  });

  // Static ValueNotifier untuk manajemen daftar student
  static final ValueNotifier<List<Student>> studentListNotifier =
      ValueNotifier<List<Student>>([]);

  // ✅ Tambah student baru
  static void addStudent(Student student) {
    studentListNotifier.value = [...studentListNotifier.value, student];
  }

  // ✅ Update student lama dengan data baru
  static void updateStudent(Student oldStudent, Student newStudent) {
    final list = [...studentListNotifier.value];
    final index = list.indexOf(oldStudent);
    if (index != -1) {
      list[index] = newStudent;
      studentListNotifier.value = list;
    }
  }

  // ✅ Hapus student
  static void deleteStudent(Student student) {
    studentListNotifier.value =
        studentListNotifier.value.where((s) => s != student).toList();
  }

  // ✅ Convert dari map (dari Supabase atau sumber lain)
  factory Student.fromMap(Map<String, dynamic> map) {
    try {
      return Student(
        nisn: map['nisn'] as String? ?? '',
        fullName: map['full_name'] as String? ?? '',
        gender: map['gender'] as String? ?? '',
        religion: map['religion'] as String? ?? '',
        birthPlace: map['birth_place'] as String? ?? '',
        birthDate: map['birth_date'] as String? ?? '',
        phoneNumber: map['phone_number'] as String? ?? '',
        nik: map['nik'] as String? ?? '',
        street: map['street'] as String? ?? '',
        rtRw: map['rt_rw'] as String? ?? '',
        dusun: map['dusun'] as String? ?? '',
        village: map['village'] as String? ?? '',
        district: map['district'] as String? ?? '',
        city: map['city'] as String? ?? '',
        province: map['province'] as String? ?? '',
        postalCode: map['postal_code'] as String? ?? '',
        fatherName: map['father_name'] as String? ?? '',
        motherName: map['mother_name'] as String? ?? '',
        guardianName: map['guardian_name'] as String?,
        studentAddress: map['student_address'] as String? ?? '',
        parentAddress: map['parent_address'] as String? ?? '',
      );
    } catch (e) {
      throw ArgumentError('Gagal membuat Student dari map: $e');
    }
  }

  // ✅ Convert ke map (untuk Supabase atau penyimpanan)
  Map<String, dynamic> toMap() {
    return {
      'nisn': nisn,
      'full_name': fullName,
      'gender': gender,
      'religion': religion,
      'birth_place': birthPlace,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
      'nik': nik,
      'street': street,
      'rt_rw': rtRw,
      'dusun': dusun,
      'village': village,
      'district': district,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'father_name': fatherName,
      'mother_name': motherName,
      'guardian_name': guardianName,
      'student_address': studentAddress,
      'parent_address': parentAddress,
    };
  }

  // ✅ Membuat salinan dengan opsi update (copyWith)
  Student copyWith({
    String? nisn,
    String? fullName,
    String? gender,
    String? religion,
    String? birthPlace,
    String? birthDate,
    String? phoneNumber,
    String? nik,
    String? street,
    String? rtRw,
    String? dusun,
    String? village,
    String? district,
    String? city,
    String? province,
    String? postalCode,
    String? fatherName,
    String? motherName,
    String? guardianName,
    String? studentAddress,
    String? parentAddress,
  }) {
    return Student(
      nisn: nisn ?? this.nisn,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nik: nik ?? this.nik,
      street: street ?? this.street,
      rtRw: rtRw ?? this.rtRw,
      dusun: dusun ?? this.dusun,
      village: village ?? this.village,
      district: district ?? this.district,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      guardianName: guardianName ?? this.guardianName,
      studentAddress: studentAddress ?? this.studentAddress,
      parentAddress: parentAddress ?? this.parentAddress,
    );
  }

  // ✅ Override equality untuk membandingkan student
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.nisn == nisn &&
        other.fullName == fullName &&
        other.gender == gender &&
        other.religion == religion &&
        other.birthPlace == birthPlace &&
        other.birthDate == birthDate &&
        other.phoneNumber == phoneNumber &&
        other.nik == nik &&
        other.street == street &&
        other.rtRw == rtRw &&
        other.dusun == dusun &&
        other.village == village &&
        other.district == district &&
        other.city == city &&
        other.province == province &&
        other.postalCode == postalCode &&
        other.fatherName == fatherName &&
        other.motherName == motherName &&
        other.guardianName == guardianName &&
        other.studentAddress == studentAddress &&
        other.parentAddress == parentAddress;
  }

  @override
  int get hashCode {
    return Object.hash(
      nisn,
      fullName,
      gender,
      religion,
      birthPlace,
      birthDate,
      phoneNumber,
      nik,
      street,
      rtRw,
      dusun,
      village,
      district,
      city,
      province,
      postalCode,
      fatherName,
      motherName,
      guardianName,
      studentAddress,
      );
  }
} 