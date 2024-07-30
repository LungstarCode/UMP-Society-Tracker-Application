

class Society {
  final String name;
  final String description;
  final String category;
 

  Society({
    required this.name,
    required this.description,
    required this.category,
  });


   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
    };
  }
}
