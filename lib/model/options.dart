class Options {
  late String  option;
  late String value;
  late String color;

  Options({
    required this.option,
    required this.value,
    required this.color,
  });

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(value: json['value'], option: '',color: '0xFFFFFFFF');
  }

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'value': value,
      'color': color,
    };
  }
}
