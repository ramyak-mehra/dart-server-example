import 'dart:html';

void main() {
  window.onLoad.listen((event) {
    setupChangeTextButton();
  });
}

Future<void> _done = Future.value();

void _enqueue(Future<void> Function() task) {
  _done = _done.then((_) => task(), onError: (e) => print('Action failed: $e'));
}

void setupChangeTextButton() {
  var changeTextButton = document.getElementById('change');

  var text = document.getElementsByTagName('p');

  changeTextButton.onClick.listen((event) {
    _enqueue(() async {
      text.first.text = 'This text was changed using js';
    });
  });
}
