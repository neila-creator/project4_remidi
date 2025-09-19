import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:developer' as developer;
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool _isDusunLoading = false;

  // Controllers
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController rtRwController = TextEditingController();
  final TextEditingController dusunController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController fatherController = TextEditingController();
  final TextEditingController motherController = TextEditingController();
  final TextEditingController guardianController = TextEditingController();
  final TextEditingController studentAddressController = TextEditingController();
  final TextEditingController parentAddressController = TextEditingController();

  final List<String> genders = ["Laki-laki", "Perempuan"];
  final List<String> religions = [
    "Islam",
    "Kristen",
    "Katolik",
    "Hindu",
    "Budha",
    "Konghucu"
  ];

  @override
  void initState() {
    super.initState();

    // Prefill jika edit
    if (widget.student != null) {
      final s = widget.student!;
      nisnController.text = s.nisn;
      fullNameController.text = s.fullName;
      genderController.text = s.gender;
      religionController.text = s.religion;
      birthPlaceController.text = s.birthPlace;
      birthDateController.text = s.birthDate;
      phoneController.text = s.phoneNumber;
      nikController.text = s.nik;
      streetController.text = s.street;
      rtRwController.text = s.rtRw;
      dusunController.text = s.dusun;
      villageController.text = s.village;
      districtController.text = s.district;
      cityController.text = s.city;
      provinceController.text = s.province;
      postalCodeController.text = s.postalCode;
      fatherController.text = s.fatherName;
      motherController.text = s.motherName;
      guardianController.text = s.guardianName ?? '';
      studentAddressController.text = s.studentAddress;
      parentAddressController.text = s.parentAddress;
      if (s.dusun.isNotEmpty) {
        _fetchDetailsByDusun(s.dusun);
      }
    }
  }

  @override
  void dispose() {
    for (var c in [
      nisnController,
      fullNameController,
      genderController,
      religionController,
      birthPlaceController,
      birthDateController,
      phoneController,
      nikController,
      streetController,
      rtRwController,
      dusunController,
      villageController,
      districtController,
      cityController,
      provinceController,
      postalCodeController,
      fatherController,
      motherController,
      guardianController,
      studentAddressController,
      parentAddressController
    ]) {
      c.dispose();
    }
    super.dispose();
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

  // ✅ DatePicker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id'),
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        birthDateController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  // ✅ Validasi custom
  String? _validateNisn(String? value) {
    if (value == null || value.isEmpty) return 'NISN wajib diisi';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'NISN harus 10 digit angka';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'No. HP wajib diisi';
    if (!RegExp(r'^(08|62|\+62)\d{8,12}$').hasMatch(value)) {
      return 'Format No. HP tidak valid (contoh: 08123456789)';
    }
    return null;
  }

  // 🔹 Ambil daftar dusun dari Supabase (untuk autocomplete)
  Future<List<String>> _fetchDusunList(String pattern) async {
    try {
      setState(() => _isDusunLoading = true);
      final response = await _supabase
          .from('dusun')
          .select('nama_dusun')
          .ilike('nama_dusun', '%$pattern%');

      return List<String>.from(response.map((row) => row['nama_dusun']));
    } catch (e) {
      developer.log("Error fetch dusun: $e");
      return [];
    } finally {
      setState(() => _isDusunLoading = false);
    }
  }

  // 🔹 Ambil detail alamat sesuai dusun
  Future<void> _fetchDetailsByDusun(String dusun) async {
    try {
      final response = await _supabase
          .from('dusun')
          .select()
          .eq('nama_dusun', dusun)
          .maybeSingle();
      if (response != null) {
        setState(() {
          villageController.text = response['desa'] ?? '';
          districtController.text = response['kecamatan'] ?? '';
          cityController.text = response['kota'] ?? '';
          provinceController.text = response['provinsi'] ?? '';
          postalCodeController.text = response['kode_pos'] ?? '';
        });
      }
    } catch (e) {
      developer.log("Error fetch detail dusun: $e");
    }
  }

  // 🔹 Simpan form (insert/update)
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'nisn': nisnController.text,
        'full_name': fullNameController.text,
        'gender': genderController.text,
        'religion': religionController.text,
        'birth_place': birthPlaceController.text,
        'birth_date': birthDateController.text,
        'phone_number': phoneController.text,
        'nik': nikController.text,
        'street': streetController.text,
        'rt_rw': rtRwController.text,
        'dusun': dusunController.text,
        'village': villageController.text,
        'district': districtController.text,
        'city': cityController.text,
        'province': provinceController.text,
        'postal_code': postalCodeController.text,
        'father_name': fatherController.text,
        'mother_name': motherController.text,
        'guardian_name': guardianController.text,
        'student_address': studentAddressController.text,
        'parent_address': parentAddressController.text,
      };

      if (widget.student == null) {
        await _supabase.from('students').insert(data);
      } else {
        await _supabase
            .from('students')
            .update(data)
            .eq('nisn', widget.student!.nisn);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Data berhasil disimpan")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      developer.log("Error save form: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal menyimpan data: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ Build field
  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool readOnly = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: readOnly && label == "Tanggal Lahir" ? _selectDate : null,
      decoration: _inputDecoration(label, icon),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) return "$label wajib diisi";
        return null;
      },
    );
  }

  Widget _buildTypeAhead(String label, TextEditingController controller,
      List<String> items, IconData icon) {
    return TypeAheadField<String>(
      suggestionsCallback: (pattern) => items
          .where((item) =>
              item.toLowerCase().contains(pattern.toLowerCase()))
          .toList(),
      itemBuilder: (context, suggestion) =>
          ListTile(title: Text(suggestion)),
      onSelected: (suggestion) => controller.text = suggestion,
      builder: (context, textEditingController, focusNode) {
        controller.value = textEditingController.value;
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: _inputDecoration(label, icon),
          validator: (value) =>
              value == null || value.isEmpty ? "$label wajib diisi" : null,
        );
      },
    );
  }

  // ✅ Dusun pakai autocomplete dari Supabase
  Widget _buildDusunField() {
    return TypeAheadField<String>(
      suggestionsCallback: _fetchDusunList,
      itemBuilder: (context, suggestion) =>
          ListTile(title: Text(suggestion)),
      onSelected: (suggestion) {
        dusunController.text = suggestion;
        _fetchDetailsByDusun(suggestion);
      },
      builder: (context, textEditingController, focusNode) {
        dusunController.value = textEditingController.value;
        return TextFormField(
          controller: dusunController,
          focusNode: focusNode,
          decoration: _inputDecoration("Dusun", Icons.map).copyWith(
            suffixIcon: _isDusunLoading
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Dusun wajib diisi" : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? "Tambah Siswa" : "Edit Siswa"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("NISN", nisnController, Icons.numbers,
                  validator: _validateNisn),
              const SizedBox(height: 10),
              _buildTextField("Nama Lengkap", fullNameController, Icons.person),
              const SizedBox(height: 10),
              _buildTypeAhead("Jenis Kelamin", genderController, genders, Icons.wc),
              const SizedBox(height: 10),
              _buildTypeAhead("Agama", religionController, religions,
                  Icons.account_balance),
              const SizedBox(height: 10),
              _buildTextField("Tempat Lahir", birthPlaceController,
                  Icons.location_city),
              const SizedBox(height: 10),
              _buildTextField("Tanggal Lahir", birthDateController,
                  Icons.calendar_today,
                  readOnly: true),
              const SizedBox(height: 10),
              _buildTextField("No. HP", phoneController, Icons.phone,
                  validator: _validatePhone),
              const SizedBox(height: 10),
              _buildTextField("NIK", nikController, Icons.credit_card),
              const SizedBox(height: 20),

              // 🔹 Alamat
              _buildTextField("Jalan", streetController, Icons.home),
              const SizedBox(height: 10),
              _buildTextField("RT/RW", rtRwController, Icons.home_repair_service),
              const SizedBox(height: 10),
              _buildDusunField(), // pakai autocomplete
              const SizedBox(height: 10),
              _buildTextField("Kelurahan/Desa", villageController,
                  Icons.location_on, readOnly: true),
              const SizedBox(height: 10),
              _buildTextField("Kecamatan", districtController, Icons.location_on,
                  readOnly: true),
              const SizedBox(height: 10),
              _buildTextField("Kota", cityController, Icons.location_city,
                  readOnly: true),
              const SizedBox(height: 10),
              _buildTextField("Provinsi", provinceController, Icons.flag,
                  readOnly: true),
              const SizedBox(height: 10),
              _buildTextField("Kode Pos", postalCodeController, Icons.mail,
                  readOnly: true),
              const SizedBox(height: 20),

              // 🔹 Orang tua
              _buildTextField("Nama Ayah", fatherController, Icons.male),
              const SizedBox(height: 10),
              _buildTextField("Nama Ibu", motherController, Icons.female),
              const SizedBox(height: 10),
              _buildTextField("Nama Wali", guardianController,
                  Icons.group_outlined),
              const SizedBox(height: 20),

              // 🔹 Alamat siswa & orang tua
              _buildTextField("Alamat Siswa", studentAddressController,
                  Icons.home_work),
              const SizedBox(height: 10),
              _buildTextField("Alamat Orang Tua", parentAddressController,
                  Icons.home_work),
              const SizedBox(height: 20),

              // ✅ Tombol simpan
              ElevatedButton(
                onPressed: _isLoading ? null : () => _saveForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text("💾 Simpan Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
