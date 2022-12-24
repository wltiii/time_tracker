/// Json is an alias for _Map<String, dynamic>_
///
/// Example usage:
/// class User {
///   final String name;
///   final int age;
///
///   User.fromJson(Json json) :
///         name = json['name'],
///         age = json['age'];
///
///   Json get toJson => {
///     'name': name,
///     'age': age,
///   };
/// }

// TODO(wltiii) will this typedef work with freezed?
// typedef Json = Map<String, Object?>;
typedef Json = Map<String, dynamic>;
