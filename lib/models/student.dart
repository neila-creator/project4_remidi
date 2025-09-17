import 'package:flutter/material.dart';

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
  final String? guardianName;
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
    required this.parentAddress,
  });

  static final ValueNotifier<List<Student>> studentListNotifier =
      ValueNotifier<List<Student>>([]);
}
