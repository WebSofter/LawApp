class Agreement {
  final String id;
  final String nomerDogovora;
  final String fullNameClient;
  final String phone;
  final String date;
  final String tematika;
  final String logo;
  final String styles;
  final String ispolnitel;
  final String epodPin;
  final String oristFio;
  final String ispolnitelPin;
  final int calling;

  Agreement({
              this.id, 
              this.nomerDogovora, 
              this.fullNameClient, 
              this.phone, 
              this.date,
              this.tematika,
              this.logo,
              this.styles,
              this.ispolnitel,
              this.epodPin,
              this.oristFio,
              this.ispolnitelPin,
              this.calling});

  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      id: json['id'] as String, 
      nomerDogovora: json['nomerDogovora'] as String, 
      fullNameClient: json['FullNameClient'] as String,  
      phone: json['phone'] as String, 
      date: json['date'] as String,
      tematika: json['tematika'] as String,
      logo: json['logo'] as String,
      styles: json['styles'] as String,
      ispolnitel: json['ispolnitel'] as String,
      epodPin: json['epodPin'] as String,
      oristFio: json['oristFio'] as String,
      ispolnitelPin: json['ispolnitelPin'] as String,
      calling: json['calling'] as int
    );
  }
}