class Language
{
  int ?id;
  String ?name;
  bool ?status;

  Language(this.id,this.name,this.status);

  factory Language.fromJson(Map<String, dynamic> jsonData)
  {
    return Language(jsonData['id'],jsonData['name'],true);
  }

  static Map<String, dynamic> toMap(Language language) => {
    'id': language.id,
    'name': language.name,
    'status': language.status,
  };
}