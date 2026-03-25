import '../models/product.dart';

class MockApiService {
  static final List<Product> _products = [
    Product(
      name: "iPhone 15 Pro",
      description: "The latest iPhone with titanium design.",
      ref: "APL-IP15P",
      image:
          "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-black-titanium-select-202309?wid=940&hei=1112&fmt=png-alpha&.v=1692879353418",
      price: 999.0,
      provider: "Apple Store",
      categoryLevel1: "Electronics",
      categoryLevel2: "Phones",
      categoryLevel3: "Smartphones",
      inStock: true,
      lat: -18.1496,
      lng: 49.4023,
    ),
    Product(
      name: "Samsung Galaxy S24",
      description: "AI powered smartphone.",
      ref: "SAM-S24",
      image:
          "https://images.samsung.com/is/image/samsung/p6pim/uk/2401/gallery/uk-galaxy-s24-s921-sm-s921bzadeub-539655160?\$650_519_PNG\$",
      price: 899.0,
      provider: "Samsung",
      categoryLevel1: "Electronics",
      categoryLevel2: "Phones",
      categoryLevel3: "Smartphones",
      inStock: true,
      lat: -18.1496,
      lng: 49.4023,
    ),
    Product(
      name: "MacBook Air M3",
      description: "Supercharged by M3.",
      ref: "APL-MBA-M3",
      image:
          "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/mba13-midnight-select-202402?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1708367688034",
      price: 1099.0,
      provider: "Apple Store",
      categoryLevel1: "Electronics",
      categoryLevel2: "Laptops",
      categoryLevel3: "Ultrabooks",
      inStock: true,
      lat: -18.1496,
      lng: 49.4023,
    ),
    Product(
      name: "Dell XPS 13",
      description: "Iconic design, powerful performance.",
      ref: "DELL-XPS13",
      image:
          "https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-13-9340/media-gallery/touch/blue/notebook-xps-13-9340-blue-gallery-1.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=536&qlt=100,1&resMode=sharp2&size=536,402&chrss=full",
      price: 1299.0,
      provider: "Dell",
      categoryLevel1: "Electronics",
      categoryLevel2: "Laptops",
      categoryLevel3: "Ultrabooks",
      inStock: false,
      lat: -18.1496,
      lng: 49.4023,
    ),
    Product(
      name: "Men's T-Shirt",
      description: "Cotton basic t-shirt.",
      ref: "CLO-M-TS",
      image:
          "https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c0792ebab9d4437682a2ac8e00ec7737_9366/Essentials_3-Stripes_Tee_White_GL0058_21_model.jpg",
      price: 19.99,
      provider: "FashionHub",
      categoryLevel1: "Clothing",
      categoryLevel2: "Men",
      categoryLevel3: "Tops",
      inStock: true,
      lat: -18.1496,
      lng: 49.4023,
    ),
    Product(
      name: "Women's Dress",
      description: "Summer floral dress.",
      ref: "CLO-W-DR",
      image:
          "https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/4f2732625292437397b2af5700f72365_9366/Tiro_23_League_Jersey_Black_HR4607_21_model.jpg",
      price: 49.99,
      provider: "FashionHub",
      categoryLevel1: "Clothing",
      categoryLevel2: "Women",
      categoryLevel3: "Dresses",
      inStock: true,
      lat: -18.1496,
      lng: 49.4023,
    ),
    Product(
      name: "Modern Sofa",
      description: "Comfortable 3-seater sofa.",
      ref: "HOM-FUR-SOF",
      image:
          "https://www.ikea.com/us/en/images/products/landskrona-sofa-gunnared-dark-gray-wood__0602115_pe680184_s5.jpg?f=s",
      price: 799.0,
      provider: "HomeStyle",
      categoryLevel1: "Home",
      categoryLevel2: "Furniture",
      categoryLevel3: "Living Room",
      inStock: true,
      lat: -18.1496,
      lng: 49.4023,
    ),
  ];

  Future<List<Product>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _products;
  }

  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _products.map((p) => p.categoryLevel1).toSet().toList();
  }
}
