class Urls {
  Urls._();

  static const String _baseUrl = "https://task.teamrabbil.com/api/v1";
  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String taskListByNew = '$_baseUrl/listTaskByStatus/New';
  static const String taskListByProgress =
      '$_baseUrl/listTaskByStatus/Progress';
  static const String taskListByCancle = '$_baseUrl/listTaskByStatus/Cancled';
  static const String taskListByCompleted =
      '$_baseUrl/listTaskByStatus/Completed';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String taskDeleteById(String taskId) => '$_baseUrl/deleteTask/$taskId';
  static String taskSatusUpdate(String taskId, String status) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';
  static String userRecoverVerifyEmail(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';
  static String otpVerification(String email, String otp) =>
      '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static const String resetUserPassword = '$_baseUrl/RecoverResetPass';
  static const String updateUserPprofile = '$_baseUrl/profileUpdate';
}
