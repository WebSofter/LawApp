class Document {
  final String name;
  final String link;
  final String type;
  final String size;
  final String date;
  Document({
              this.name, 
              this.link,  
              this.type, 
              this.size, 
              this.date});
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'] as String, 
      link: json['link'] as String, 
      type: json['type'] as String, 
      size: json['size'] as String, 
      date: json['date'] as String,
    );
  }
}