enum Routes {
  splash,
  login,
  register,
  allUsers,
  chatList,
  chat;

  String get path => '/${name.toString()}';
}
