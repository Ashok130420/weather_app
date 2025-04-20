class AppException implements Exception {
  final int? status;
  final String? message;
  final dynamic data;

  AppException([this.status, this.message, this.data]);

  @override
  String toString() {
    //return "$_status$_message$_data";
    return 'ApiException{status: $status, message: $message, data: $data}';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(900, message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(900, message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
      : super(900, message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(900, message, "Invalid Input: ");
}
