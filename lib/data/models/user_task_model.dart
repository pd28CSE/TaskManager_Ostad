class UserTaskListModel {
  final String status;
  final List<UserTaskModel> usertaskList;

  UserTaskListModel({required this.status, required this.usertaskList});

  factory UserTaskListModel.fromJson(Map<String, dynamic> json) {
    List<UserTaskModel> list = [];
    for (var item in json['data']) {
      list.add(UserTaskModel.fromJson(item));
    }

    // List<UserTaskModel> listadat =
    //     json['data'].map((task) => UserTaskModel.fromJson(task)).toList();

    return UserTaskListModel(
      status: json['status'],
      usertaskList: list,
    );
  }
}

class UserTaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String createdDate;

  UserTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  factory UserTaskModel.fromJson(Map<String, dynamic> json) {
    return UserTaskModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      createdDate: json['createdDate'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson(UserTaskModel userTask) {
    return {
      '_id': userTask.id,
      'title': userTask.title,
      'description': userTask.description,
      'createdDate': userTask.createdDate,
      'status': userTask.status,
    };
  }
}
