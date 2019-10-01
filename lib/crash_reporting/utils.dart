bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;
  // Assert expressions are only evaluated during development.
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
  } else {
    // Send the Exception and Stacktrace to Backend
    print('TODO: send error to backend');
  }
}
