class TaskStatusCount {
  String? status;
  List<TaskStatusModel>? data;

  TaskStatusCount({this.status, this.data});

  TaskStatusCount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TaskStatusModel>[];
      json['data'].forEach((v) {
        data!.add(TaskStatusModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskStatusModel {
  String? id;
  int? sum;

  TaskStatusModel({this.id, this.sum});

  TaskStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['sum'] = sum;
    return data;
  }
}
