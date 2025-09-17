import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;
  const StudentFormScreen({super.key, this.student});

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _rtRwController = TextEditingController();
  final TextEditingController _dusunController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _studentAddressController = TextEditingController(); // Alamat Siswa
  final TextEditingController _parentAddressController = TextEditingController(); // Alamat Orang Tua

  String? _gender;
  String? _religion;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.fullName;
      _nisnController.text = widget.student!.nisn;
      _birthDateController.text = widget.student!.birthDate;
      _birthPlaceController.text = widget.student!.birthPlace;
      _phoneNumberController.text = widget.student!.phoneNumber;
      _nikController.text = widget.student!.nik;
      _streetController.text = widget.student!.street;
      _rtRwController.text = widget.student!.rtRw;
      _dusunController.text = widget.student!.dusun;
      _villageController.text = widget.student!.village;
      _districtController.text = widget.student!.district;
      _cityController.text = widget.student!.city;
      _provinceController.text = widget.student!.province;
      _postalCodeController.text = widget.student!.postalCode;
      _fatherNameController.text = widget.student!.fatherName;
      _motherNameController.text = widget.student!.motherName;
      _guardianNameController.text = widget.student!.guardianName ?? '';
      _studentAddressController.text = widget.student!.parentAddress; // Sementara pakai parentAddress
      _parentAddressController.text = widget.student!.parentAddress; // Sementara pakai parentAddress
      _gender = widget.student!.gender;
      _religion = widget.student!.religion;
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.blue.shade50,
    );
  }

  Future<void> _selectDate() async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('id'), // Bahasa Indonesia
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          _birthDateController.text = DateFormat("dd-MM-yyyy").format(picked);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih tanggal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi Data Siswa"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya (misalnya home)
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nisnController,
                    decoration: _inputDecoration("NISN", Icons.badge),
                    validator: (val) =>
                        val!.isEmpty ? "NISN tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration("Nama Lengkap", Icons.person),
                    validator: (val) =>
                        val!.isEmpty ? "Nama tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: _inputDecoration("Jenis Kelamin", Icons.people),
                    items: const [
                      DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
                      DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
                    ],
                    onChanged: (val) => setState(() => _gender = val),
                    validator: (val) =>
                        val == null ? "Pilih jenis kelamin" : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _religion,
                    decoration: _inputDecoration("Agama", Icons.star),
                    items: const [
                      DropdownMenuItem(value: "Islam", child: Text("Islam")),
                      DropdownMenuItem(value: "Kristen", child: Text("Kristen")),
                      DropdownMenuItem(value: "Katolik", child: Text("Katolik")),
                      DropdownMenuItem(value: "Hindu", child: Text("Hindu")),
                      DropdownMenuItem(value: "Budha", child: Text("Budha")),
                      DropdownMenuItem(value: "Konghucu", child: Text("Konghucu")),
                    ],
                    onChanged: (val) => setState(() => _religion = val),
                    validator: (val) => val == null ? "Pilih agama" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration:
                        _inputDecoration("Tanggal Lahir", Icons.calendar_today),
                    validator: (val) =>
                        val!.isEmpty ? "Tanggal lahir wajib diisi" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthPlaceController,
                    decoration: _inputDecoration("Tempat Lahir", Icons.location_city),
                    validator: (val) =>
                        val!.isEmpty ? "Tempat lahir tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: _inputDecoration("Nomor Telepon", Icons.phone),
                    validator: (val) =>
                        val!.isEmpty ? "Nomor telepon tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nikController,
                    decoration: _inputDecoration("NIK", Icons.credit_card),
                    validator: (val) =>
                        val!.isEmpty ? "NIK tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _streetController,
                    decoration: _inputDecoration("Jalan", Icons.streetview),
                    validator: (val) =>
                        val!.isEmpty ? "Jalan tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _rtRwController,
                    decoration: _inputDecoration("RT/RW", Icons.format_list_numbered),
                    validator: (val) =>
                        val!.isEmpty ? "RT/RW tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dusunController,
                    decoration: _inputDecoration("Dusun", Icons.home),
                    validator: (val) =>
                        val!.isEmpty ? "Dusun tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _villageController,
                    decoration: _inputDecoration("Desa", Icons.location_city),
                    validator: (val) =>
                        val!.isEmpty ? "Desa tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _districtController,
                    decoration: _inputDecoration("Kecamatan", Icons.map),
                    validator: (val) =>
                        val!.isEmpty ? "Kecamatan tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cityController,
                    decoration: _inputDecoration("Kota", Icons.location_on),
                    validator: (val) =>
                        val!.isEmpty ? "Kota tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _provinceController,
                    decoration: _inputDecoration("Provinsi", Icons.map),
                    validator: (val) =>
                        val!.isEmpty ? "Provinsi tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _postalCodeController,
                    decoration: _inputDecoration("Kode Pos", Icons.local_post_office),
                    validator: (val) =>
                        val!.isEmpty ? "Kode pos tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fatherNameController,
                    decoration: _inputDecoration("Nama Ayah", Icons.person),
                    validator: (val) =>
                        val!.isEmpty ? "Nama ayah tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _motherNameController,
                    decoration: _inputDecoration("Nama Ibu", Icons.person),
                    validator: (val) =>
                        val!.isEmpty ? "Nama ibu tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _guardianNameController,
                    decoration: _inputDecoration("Nama Wali (jika ada)", Icons.person),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _studentAddressController,
                    decoration: _inputDecoration("Alamat Siswa", Icons.home),
                    validator: (val) =>
                        val!.isEmpty ? "Alamat siswa tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parentAddressController,
                    decoration: _inputDecoration("Alamat Orang Tua", Icons.home),
                    validator: (val) =>
                        val!.isEmpty ? "Alamat orang tua tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 20),
                  if (!_isEditing)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  if (_isEditing)
                    Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Simpan"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final newStudent = Student(
                                nisn: _nisnController.text,
                                fullName: _nameController.text,
                                gender: _gender!,
                                religion: _religion!,
                                birthPlace: _birthPlaceController.text,
                                birthDate: _birthDateController.text,
                                phoneNumber: _phoneNumberController.text,
                                nik: _nikController.text,
                                street: _streetController.text,
                                rtRw: _rtRwController.text,
                                dusun: _dusunController.text,
                                village: _villageController.text,
                                district: _districtController.text,
                                city: _cityController.text,
                                province: _provinceController.text,
                                postalCode: _postalCodeController.text,
                                fatherName: _fatherNameController.text,
                                motherName: _motherNameController.text,
                                guardianName: _guardianNameController.text.isEmpty
                                    ? null
                                    : _guardianNameController.text,
                                parentAddress: _parentAddressController.text,
                              );
                              Student.studentListNotifier.value = [
                                ...Student.studentListNotifier.value,
                                newStudent
                              ];
                              setState(() {
                                _isEditing = false;
                              });
                              Navigator.pop(context);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.blue.shade100,
        child: const Text(
          "Untuk Menambahkan Data",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}