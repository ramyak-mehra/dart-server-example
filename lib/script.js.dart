import 'dart:html';

//Script for changing the text on the laniding page on click of the button.
//It's there to see how we can write dart code and compile it to js using dart2js and
//use it for dom manipulation
void main() {
  window.onLoad.listen((event) {
    setupChangeTextButton();
  });
}

Future<void> _done = Future.value();
//This prevents it from running more than one time.
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
