class ProdukDigital {
  String namaProduk;
  double harga;
  String kategori;

  ProdukDigital(this.namaProduk, this.harga, this.kategori) {
    if (kategori == 'NetworkAutomation' && harga < 200000) {
      throw Exception('Harga produk NetworkAutomation harus minimal 200000');
    } else if (kategori == 'DataManagement' && harga >= 200000) {
      throw Exception('Harga produk DataManagement harus di bawah 200000');
    }
  }

  void terapkanDiskon(int jumlahTerjual) {
    if (kategori == 'NetworkAutomation' && jumlahTerjual > 50) {
      double hargaDiskon = harga * 0.85;
      harga = hargaDiskon < 200000 ? 200000 : hargaDiskon;
    }
  }
}

abstract class Karyawan {
  String nama;
  int umur;
  String peran;

  Karyawan(this.nama, {required this.umur, required this.peran});

  void bekerja();
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama bekerja secara reguler');
  }
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama bekerja sesuai proyek');
  }
}

mixin Kinerja {
  int produktivitas = 0;
  DateTime lastUpdate = DateTime.now();

  void updateProduktivitas(int nilai) {
    if (DateTime.now().difference(lastUpdate).inDays >= 30) {
      produktivitas = (produktivitas + nilai).clamp(0, 100);
      lastUpdate = DateTime.now();
    } else {
      print('Produktivitas hanya dapat diperbarui setiap 30 hari.');
    }
  }
}

class Manager extends Karyawan with Kinerja {
  Manager(String nama, {required int umur})
      : super(nama, umur: umur, peran: 'Manager') {
    if (produktivitas < 85) {
      produktivitas = 85;
    }
  }

  @override
  void bekerja() {
    print('$nama bekerja sebagai Manager');
  }
}

enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

class Proyek {
  FaseProyek fase = FaseProyek.Perencanaan;
  int jumlahHari = 0;
  int jumlahKaryawanAktif = 0;

  void lanjutkanFase() {
    if (fase == FaseProyek.Perencanaan && jumlahKaryawanAktif >= 5) {
      fase = FaseProyek.Pengembangan;
      print('Proyek beralih ke fase Pengembangan');
    } else if (fase == FaseProyek.Pengembangan && jumlahHari > 45) {
      fase = FaseProyek.Evaluasi;
      print('Proyek beralih ke fase Evaluasi');
    } else {
      print('Syarat untuk beralih ke fase berikutnya belum terpenuhi.');
    }
  }
}

class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  int batasKaryawanAktif = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < batasKaryawanAktif) {
      karyawanAktif.add(karyawan);
      print('Karyawan ${karyawan.nama} berhasil ditambahkan.');
    } else {
      print('Jumlah karyawan aktif sudah mencapai batas maksimal.');
    }
  }

  void resignKaryawan(Karyawan karyawan) {
    if (karyawanAktif.contains(karyawan)) {
      karyawanAktif.remove(karyawan);
      karyawanNonAktif.add(karyawan);
      print('Karyawan ${karyawan.nama} telah resign.');
    } else {
      print('Karyawan tidak ditemukan dalam daftar karyawan aktif.');
    }
  }
}

void main() {
  ProdukDigital produk = ProdukDigital('NetworkAutomationX', 250000, 'NetworkAutomation');
  produk.terapkanDiskon(60);
  print('Harga setelah diskon: ${produk.harga}');

  KaryawanTetap dev = KaryawanTetap('Andi', umur: 30, peran: 'Developer');
  dev.bekerja();

  Manager mgr = Manager('Budi', umur: 45);
  mgr.updateProduktivitas(10);
  print('Produktivitas Manager: ${mgr.produktivitas}');

  Proyek proyek = Proyek();
  proyek.jumlahKaryawanAktif = 5;
  proyek.lanjutkanFase();
  proyek.jumlahHari = 50;  
  proyek.lanjutkanFase();
  print('Fase proyek saat ini: ${proyek.fase}');

  Perusahaan perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(dev);
  perusahaan.tambahKaryawan(mgr);
  perusahaan.resignKaryawan(dev);
  perusahaan.resignKaryawan(mgr);
}