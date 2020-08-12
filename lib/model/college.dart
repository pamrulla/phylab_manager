class College {
  String name = "";
  String city = "";
  String code = "";
  String id = "";
  int students = 0;

  College({this.name, this.city, this.code, this.id, this.students});

  void info() {
    print("College Details");
    print("Name: " + name);
    print("city: " + city);
    print("code: " + code);
    print("id: " + id);
  }
}
