import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student; // kalau null berarti tambah, kalau ada berarti edit

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap input
  late TextEditingController nisnCtrl;
  late TextEditingController nameCtrl;
  late TextEditingController birthPlaceCtrl;
  late TextEditingController birthDateCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController nikCtrl;
  late TextEditingController streetCtrl;
  late TextEditingController rtRwCtrl;
  late TextEditingController dusunCtrl;
  late TextEditingController villageCtrl;
  late TextEditingController districtCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController provinceCtrl;
  late TextEditingController postalCodeCtrl;
  late TextEditingController fatherNameCtrl;
  late TextEditingController motherNameCtrl;
  late TextEditingController guardianNameCtrl;
  late TextEditingController studentAddressCtrl;
  late TextEditingController parentAddressCtrl;

  String? gender;
  String? religion;

  @override
  void initState() {
    super.initState();

    final s = widget.student;
    nisnCtrl = TextEditingController(text: s?.nisn ?? "");
    nameCtrl = TextEditingController(text: s?.fullName ?? "");
    gender = s?.gender;
    religion = s?.religion;
    birthPlaceCtrl = TextEditingController(text: s?.birthPlace ?? "");
    birthDateCtrl = TextEditingController(text: s?.birthDate ?? "");
    phoneCtrl = TextEditingController(text: s?.phoneNumber ?? "");
    nikCtrl = TextEditingController(text: s?.nik ?? "");
    streetCtrl = TextEditingController(text: s?.street ?? "");
    rtRwCtrl = TextEditingController(text: s?.rtRw ?? "");
    dusunCtrl = TextEditingController(text: s?.dusun ?? "");
    villageCtrl = TextEditingController(text: s?.village ?? "");
    districtCtrl = TextEditingController(text: s?.district ?? "");
    cityCtrl = TextEditingController(text: s?.city ?? "");
    provinceCtrl = TextEditingController(text: s?.province ?? "");
    postalCodeCtrl = TextEditingController(text: s?.postalCode ?? "");
    fatherNameCtrl = TextEditingController(text: s?.fatherName ?? "");
    motherNameCtrl = TextEditingController(text: s?.motherName ?? "");
    guardianNameCtrl = TextEditingController(text: s?.guardianName ?? "");
    studentAddressCtrl = TextEditingController(text: s?.studentAddress ?? "");
    parentAddressCtrl = TextEditingController(text: s?.parentAddress ?? "");
  }

  @override
  void dispose() {
    nisnCtrl.dispose();
    nameCtrl.dispose();
    birthPlaceCtrl.dispose();
    birthDateCtrl.dispose();
    phoneCtrl.dispose();
    nikCtrl.dispose();
    streetCtrl.dispose();
    rtRwCtrl.dispose();
    dusunCtrl.dispose();
    villageCtrl.dispose();
    districtCtrl.dispose();
    cityCtrl.dispose();
    provinceCtrl.dispose();
    postalCodeCtrl.dispose();
    fatherNameCtrl.dispose();
    motherNameCtrl.dispose();
    guardianNameCtrl.dispose();
    studentAddressCtrl.dispose();
    parentAddressCtrl.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        nisn: nisnCtrl.text,
        fullName: nameCtrl.text,
        gender: gender ?? "",
        religion: religion ?? "",
        birthPlace: birthPlaceCtrl.text,
        birthDate: birthDateCtrl.text,
        phoneNumber: phoneCtrl.text,
        nik: nikCtrl.text,
        street: streetCtrl.text,
        rtRw: rtRwCtrl.text,
        dusun: dusunCtrl.text,
        village: villageCtrl.text,
        district: districtCtrl.text,
        city: cityCtrl.text,
        province: provinceCtrl.text,
        postalCode: postalCodeCtrl.text,
        fatherName: fatherNameCtrl.text,
        motherName: motherNameCtrl.text,
        guardianName: guardianNameCtrl.text,
        studentAddress: studentAddressCtrl.text,
        parentAddress: parentAddressCtrl.text,
      );

      if (widget.student == null) {
        Student.addStudent(newStudent);
      } else {
        Student.updateStudent(widget.student!, newStudent);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        birthDateCtrl.text = "${date.day}-${date.month}-${date.year}";
      });
    }
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool required) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: required
          ? (val) => val == null || val.isEmpty ? "$label wajib diisi" : null
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null
            ? "Tambah Data Siswa"
            : "Edit Data Siswa"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField("NISN", nisnCtrl, true),
              const SizedBox(height: 12),
              _buildTextField("Nama Lengkap", nameCtrl, true),
              const SizedBox(height: 12),

              // Jenis Kelamin
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(
                    labelText: "Jenis Kelamin", border: OutlineInputBorder()),
                items: ["Laki-laki", "Perempuan"]
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => gender = val),
                validator: (val) =>
                    val == null ? "Jenis Kelamin wajib dipilih" : null,
              ),
              const SizedBox(height: 12),

              // Agama
              DropdownButtonFormField<String>(
                value: religion,
                decoration: const InputDecoration(
                    labelText: "Agama", border: OutlineInputBorder()),
                items: ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu"]
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => religion = val),
                validator: (val) =>
                    val == null ? "Agama wajib dipilih" : null,
              ),
              const SizedBox(height: 12),

              _buildTextField("Tempat Lahir", birthPlaceCtrl, true),
              const SizedBox(height: 12),

              TextFormField(
                controller: birthDateCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickDate,
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Tanggal lahir wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              _buildTextField("No. HP", phoneCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("NIK", nikCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Jalan", streetCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("RT/RW", rtRwCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Dusun", dusunCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Desa/Kelurahan", villageCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Kecamatan", districtCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Kota/Kabupaten", cityCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Provinsi", provinceCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Kode Pos", postalCodeCtrl, false),
              const SizedBox(height: 12),

              _buildTextField("Nama Ayah", fatherNameCtrl, true),
              const SizedBox(height: 12),
              _buildTextField("Nama Ibu", motherNameCtrl, true),
              const SizedBox(height: 12),
              _buildTextField("Nama Wali", guardianNameCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Alamat Siswa", studentAddressCtrl, false),
              const SizedBox(height: 12),
              _buildTextField("Alamat Orang Tua", parentAddressCtrl, false),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveStudent,
                icon: const Icon(Icons.save),
                label: const Text("Simpan Data"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
