class ClientResponse<T> {
  T? data;
  String? errorMessage;
  bool isError;

  ClientResponse({
    required this.data,
    required this.isError,
    this.errorMessage,
  });
}
