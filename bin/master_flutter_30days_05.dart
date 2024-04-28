import 'dart:async';

void main(List<String> arguments) {
  // Use Future to handle async operation
  fetchUserOrder().then((value) {
    print('User order: $value');
  });

  // Use Future to handle async operation with error
  fetchUserOrderError().then(
    (value) {
      print('User order: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
  );

  // Use async/await to handle async operation
  fetchUserOrderAsync().then((value) {
    print('User order: $value');
  });

  // Use async/await to handle async operation with error
  fetchUserOrderErrorAsync().then(
    (value) {
      print('User order: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
  );

  // Use Completer to handle async operation
  fetchUserOrderUseCompleter().then((value) {
    print('User order: $value');
  });

  // Single subscription stream
  getNumbers1().listen(
    (value) {
      print('getNumbers1: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
    onDone: () {
      print('getNumbers1 stream completed');
    },
  );
  getNumbers2().listen(
    (value) {
      print('getNumbers2: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
    onDone: () {
      print('getNumbers2 stream completed');
    },
  );

  // Single subscription stream with async*
  getNumbers3().listen(
    (value) {
      print('getNumbers3: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
    onDone: () {
      print('getNumbers3 stream completed');
    },
  );

  // Broadcast stream
  getNumbers1Broadcast().listen(
    (value) {
      print('getNumbers1Broadcast: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
    onDone: () {
      print('getNumbers1Broadcast stream completed');
    },
  );
  getNumbers2Broadcast().listen(
    (value) {
      print('getNumbers2Broadcast: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
    onDone: () {
      print('getNumbers2Broadcast stream completed');
    },
  );
}

Future<String> fetchUserOrder() => Future.delayed(
      Duration(seconds: 5),
      () => 'Large Latte',
    );

Future<String> fetchUserOrderError() => Future.delayed(
      Duration(seconds: 5),
      () => throw Exception('Out of milk'),
    );

Future<String> fetchUserOrderAsync() async {
  await Future.delayed(Duration(seconds: 5));
  return 'Large Latte';
}

Future<String> fetchUserOrderErrorAsync() async {
  try {
    return await Future.delayed(
      Duration(seconds: 5),
      () => throw Exception('Out of milk'),
    );
  } catch (e) {
    rethrow;
  }
}

Future<String> fetchUserOrderUseCompleter() {
  Completer<String> completer = Completer<String>();

  Future.delayed(Duration(seconds: 5), () {
    completer.complete('Large Latte');
  });

  return completer.future;
}

Stream<int> getNumbers1() {
  return Stream.periodic(Duration(seconds: 1), (i) => i + 1).take(5);
}

Stream<int> getNumbers2() {
  StreamController<int> controller = StreamController<int>();

  // 在另一個isolate或Future中執行以下代碼
  Future(() {
    for (int i = 1; i <= 5; i++) {
      controller.sink.add(i);
      Future.delayed(Duration(seconds: 1));
    }
    controller.sink.close();
  });

  return controller.stream;
}

Stream<int> getNumbers3() async* {
  for (int i = 1; i <= 5; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

Stream<int> getNumbers1Broadcast() {
  return Stream.periodic(Duration(seconds: 1), (i) => i + 1)
      .take(5)
      .asBroadcastStream();
}

Stream<int> getNumbers2Broadcast() {
  StreamController<int> controller = StreamController<int>.broadcast();

  // 在另一個isolate或Future中執行以下代碼
  Future(() {
    for (int i = 1; i <= 5; i++) {
      controller.sink.add(i);
      Future.delayed(Duration(seconds: 1));
    }
    controller.sink.close();
  });

  return controller.stream;
}
