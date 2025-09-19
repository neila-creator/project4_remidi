import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  final supabase = Supabase.instance.client;

  // Controller untuk input data
  final namaCtrl = TextEditingController();
  final nisnCtrl = TextEditingController();

  // Simpan data siswa (Create)
  Future<void> tambahSiswa() async {
    if (namaCtrl.text.isEmpty || nisnCtrl.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama wajib diisi & NISN harus 10 digit')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menyimpan data ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Simpan")),
        ],
      ),
    );

    if (confirm == true) {
      await supabase.from('siswa').insert({
        'nama_lengkap': namaCtrl.text,
        'nisn': nisnCtrl.text,
        'jenis_kelamin': 'Laki-laki',
        'agama': 'Islam',
        'tempat_lahir': 'Jakarta',
        'tanggal_lahir': '2005-01-01',
        'nik': '1234567890123456',
        'jalan': 'Jl. Mawar No. 1',
        'rt': 1,
        'rw': 2,
        'no_hp': '081234567890',
      });

      namaCtrl.clear();
      nisnCtrl.clear();
      setState(() {});
    }
  }

  // Ambil semua siswa (Read)
  Future<List<Map<String, dynamic>>> ambilSiswa() async {
    final response = await supabase.from('siswa').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Ubah data siswa (Update)
  Future<void> ubahSiswa(String id, String namaBaru) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin mengubah data ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Ubah")),
        ],
      ),
    );

    if (confirm == true) {
      await supabase.from('siswa').update({'nama_lengkap': namaBaru}).eq('id_siswa', id);
      setState(() {});
    }
  }

  // Hapus data siswa (Delete)
  Future<void> hapusSiswa(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (confirm == true) {
      await supabase.from('siswa').delete().eq('id_siswa', id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD Siswa")),
      body: Column(
        children: [
          // Form input tambah siswa
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
                TextField(controller: nisnCtrl, decoration: const InputDecoration(labelText: 'NISN (10 digit)')),
                ElevatedButton(onPressed: tambahSiswa, child: const Text("Simpan")),
              ],
            ),
          ),

          const Divider(),

          // Tampilkan daftar siswa
          Expanded(
            child: FutureBuilder(
              future: ambilSiswa(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    final siswa = data[i];
                    return ListTile(
                      title: Text(siswa['nama_lengkap']),
                      subtitle: Text("NISN: ${siswa['nisn']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => ubahSiswa(siswa['id_siswa'], "${siswa['nama_lengkap']} (Updated)"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => hapusSiswa(siswa['id_siswa']),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
