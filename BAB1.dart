import 'dart:async';


enum Role { Admin, Customer }


class Product {
  final String productName;
  final double price;
  final bool inStock;

  Product({
    required this.productName,
    required this.price,
    required this.inStock,
  });
}

class User {
  String name;
  int age;
  late List<Product> products; // Inisialisasi menggunakan late
  Role? role;

  User({required this.name, required this.age, this.role});

  void viewProducts() {
    if (products.isEmpty) {
      print("Tidak ada produk tersedia.");
    } else {
      print("Daftar Produk:");
      for (var product in products) {
        print("Nama: ${product.productName}, Harga: Rp${product.price}, Tersedia: ${product.inStock}");
      }
    }
  }
}

class AdminUser extends User {
  AdminUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Admin) {
    products = [];
  }

  void addProduct(Product product, Map<String, Product> productCatalog, Set<String> productSet) {
    try {
      // Mengecek ketersediaan stok
      if (!product.inStock) {
        throw Exception("Produk ${product.productName} tidak tersedia dalam stok!");
      }
      // Menambahkan produk ke set untuk memastikan tidak ada duplikasi
      if (productSet.add(product.productName)) {
        products.add(product);
        productCatalog[product.productName] = product;
        print("Produk ${product.productName} berhasil ditambahkan.");
      } else {
        print("Produk ${product.productName} sudah ada di katalog.");
      }
    } catch (e) {
      print("Error saat menambahkan produk: ${e}");
    }
  }

  void removeProduct(String productName, Map<String, Product> productCatalog) {
    var product = productCatalog[productName];
    if (product != null) {
      products.remove(product);
      productCatalog.remove(productName);
      print("Produk $productName berhasil dihapus.");
    } else {
      print("Produk $productName tidak ditemukan di katalog.");
    }
  }
}

class CustomerUser extends User {
  CustomerUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Customer) {
    products = [];
  }

  @override
  void viewProducts() {
    super.viewProducts();
  }
}
  
Future<void> fetchProductDetails(Product product) async {
  print("Mengambil detail untuk ${product.productName}...");
  await Future.delayed(Duration(seconds: 2));
  print("Detail ${product.productName}: Harga: Rp${product.price}, Tersedia: ${product.inStock}");
}

void main() async {
 
  Map<String, Product> productCatalog = {};
  Set<String> productSet = {};
  
  var admin = AdminUser(name: "Alice", age: 30);
  var customer = CustomerUser(name: "Bob", age: 25);

    var product1 = Product(productName: "Laptop", price: 15000000, inStock: true);
  var product2 = Product(productName: "Smartphone", price: 8000000, inStock: false);
  var product3 = Product(productName: "Headphone", price: 2000000, inStock: true);

 admin.addProduct(product1, productCatalog, productSet); 
  admin.addProduct(product2, productCatalog, productSet); 
  admin.addProduct(product3, productCatalog, productSet); 

   admin.removeProduct("Smartphone", productCatalog);

  print("\nProduk yang dapat dilihat oleh Customer:");
  customer.viewProducts();

  print("\nProduk yang dapat dilihat oleh Admin:");
  admin.viewProducts();


  await fetchProductDetails(product1);
} 