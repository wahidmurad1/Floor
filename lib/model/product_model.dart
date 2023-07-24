class ProductModel {
  int id;
  String title;
  double price;
  String description;
  Category category;
  String image;
  Rating rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
}

enum Category { MEN_S_CLOTHING, JEWELERY, ELECTRONICS, WOMEN_S_CLOTHING }

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });
}
