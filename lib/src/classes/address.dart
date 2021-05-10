


class Address{
  String country;
  String city;
  String state;
  String addressLine;
  double longitude;
  double latitude;

  Address({
    this.country,
    this.city,
    this.state,
    this .addressLine,
    this. longitude,
    this.latitude
  });

  factory Address.fromJson(dynamic json) =>Address(
    country: json["country"] == null ? null : json["country"],
    state: json["state"] == null ? null : json["state"],
    city: json["city"] == null ? null : json["city"],
    addressLine: json["addressLine"] == null ? null : json["addressLine"],
    latitude: json["lat"] == null ? null : json["lat"].toDouble(),
    longitude: json["lng"] == null ? null : json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'country': this.country,
    'state': this.state,
    'city': this.city == null? "": this.city,
    'addressLine': this.addressLine == null? "": this.addressLine,
    'lat': this.latitude == null? 0.0: this.latitude,
    'lng': this.longitude == null? 0.0: this.longitude
  };
}

