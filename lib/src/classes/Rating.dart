

class Rating {
  double good;
  double medieum;
  double bad;
  double rate;
  Rating({this.good, this.medieum, this.bad, this.rate});

  factory Rating.fromJson(dynamic json) => Rating(
    good: json["good"] == null ? null : json["good"].toDouble(),
    medieum:json["medieum"] == null ? null : json["medieum"].toDouble(),
    bad: json["bad"] == null ? null : json["bad"].toDouble(),
    rate:json["rate"] == null ? null : json["rate"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'good': this.good == null? 0 : this.good,
    'medieum': this.medieum == null? 0 : this.medieum,
    'bad': this.bad == null? 0: this.bad,
    'rate': this.rate == null? 0 : this.rate
  };
}