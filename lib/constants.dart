import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

//  login
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const defaultPadding = 16.0;

// pos

// Colors
var appBarColor = const Color(0XFF0C2844);

var buttonColors =
    WindowButtonColors(iconNormal: Colors.white, mouseDown: Colors.black);

var buttonColors2 = WindowButtonColors(
    iconNormal: Colors.white,
    mouseDown: Colors.black,
    mouseOver: Colors.red[600],
    iconMouseOver: Colors.white);

var defaultAccentColor = const Color(0XFF1BC6C1);

var defaultBgAccentColor = const Color.fromARGB(97, 27, 198, 192);

var defaultBackgroundColor = Colors.white;

// ignore: prefer_const_constructors
var defaultTextColor = Color.fromARGB(255, 248, 249, 249);

var drawerTextColor = TextStyle(
  color: defaultTextColor,
  fontFamily: GoogleFonts.poppins().fontFamily,
);

var defaultIconColor = const Color.fromARGB(181, 12, 40, 68);

var tilePrimaryColor = Colors.grey[400];

var tileSecondaryColor = Colors.grey[100];

List<Color> pieChartColorPalette = const [
  Color(0XFF0C2844),
  Color(0xFF384166),
  Color(0xFF655B87),
  Color(0xFF252422),
  Color(0xFFEB5E28),
];

// Application Components - Variables
// var windowsAppBar = PreferredSize(
//   preferredSize: const Size.fromHeight(36.0),
//   child: AppBar(
//     backgroundColor: appBarColor,
//     title: Column(
//       children: [
//         WindowTitleBarBox(
//           child: Row(
//             children: [
//               Expanded(
//                 child: MoveWindow(),
//               ),
//               MinimizeWindowButton(colors: buttonColors),
//               MaximizeWindowButton(colors: buttonColors),
//               CloseWindowButton(colors: buttonColors2),
//             ],
//           ),
//         ),
//       ],
//     ),
//     centerTitle: false,
//   ),
// );

var handheldAppBar = PreferredSize(
  preferredSize: const Size.fromHeight(36.0),
  child: AppBar(
    backgroundColor: appBarColor,
    title: const Column(),
    centerTitle: false,
  ),
);

var tilePadding = const EdgeInsets.only(left: 8, right: 8, top: 8);
var settingsCategoryPadding =
    const EdgeInsets.only(left: 16, right: 16, top: 16);

var customTextField = TextField(
  style: GoogleFonts.poppins(
    color: Colors.white,
  ),
  decoration: InputDecoration(
    hintText: 'Enter Value',
    hintStyle: GoogleFonts.poppins(
      color: Colors.grey,
      fontSize: 15,
    ),
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    fillColor: tileSecondaryColor,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: tilePrimaryColor!),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: tilePrimaryColor!),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: tilePrimaryColor!),
    ),
  ),
);

// Application Components - Parameterized
void customOKAlertDialog(
    BuildContext context, String cTitle, String cMessage, String cOKLabel) {
  showOkAlertDialog(
    context: context,
    title: cTitle,
    message: cMessage,
    okLabel: cOKLabel,
    builder: (context, child) => Theme(
      data: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: defaultBackgroundColor,
            textStyle: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: defaultAccentColor,
          ),
        ),
      ),
      child: child,
    ),
  );
}

// var connectionWidget = OfflineBuilder(
//   connectivityBuilder: (context, connectivity, child) {
//     if (connectivity == ConnectivityResult.none) {
//       connectionStatus = false;
//       log("offline");
//       return const SizedBox.shrink();
//     } else {
//       connectionStatus = true;
//       log("online");
//       return child;
//     }
//   },
//   builder: (BuildContext context) {
//     return const SizedBox.shrink();
//   },
// );

enum DialogsAction { yes, cancel }

class AlertDialogs {
  get context => null;

  static Future<DialogsAction> okCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color(0xFFC41A3B), fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
              child: const Text(
                'Confirm',
                style: TextStyle(
                    color: Color(0xFFC41A3B), fontWeight: FontWeight.w700),
              ),
            )
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }

  static Future<bool> getOkCancelDialogResult(BuildContext context) async {
    final action =
        await AlertDialogs.okCancelDialog(context, 'Logout', 'are you sure ?');
    if (action == DialogsAction.yes) {
      return true;
    } else {
      return false;
    }
  }
}

class TextKeyTablet extends StatelessWidget {
  const TextKeyTablet({
    required Key key,
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  }) : super(key: key);
  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: defaultBgAccentColor,
          child: InkWell(
            onTap: () {
              onTextInput.call(text);
            },
            child: Center(
                child: Text(
              text,
              style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 20,
                  color: defaultTextColor,
                  fontWeight: FontWeight.w900),
            )),
          ),
        ),
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    required Key key,
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  }) : super(key: key);
  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: defaultBgAccentColor,
          child: InkWell(
            onTap: () {
              onTextInput.call(text);
            },
            child: Center(
                child: Text(
              text,
              style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 26,
                  color: defaultTextColor,
                  fontWeight: FontWeight.w900),
            )),
          ),
        ),
      ),
    );
  }
}

class BackspaceKeyTablet extends StatelessWidget {
  const BackspaceKeyTablet({
    required Key key,
    required this.onBackspace,
    this.flex = 1,
  }) : super(key: key);
  final VoidCallback onBackspace;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: defaultBgAccentColor,
          child: InkWell(
            onTap: () {
              onBackspace.call();
            },
            child: Center(
              child: Icon(
                Icons.backspace,
                color: defaultTextColor,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    required Key key,
    required this.onBackspace,
    this.flex = 1,
  }) : super(key: key);
  final VoidCallback onBackspace;
  final int flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: defaultBgAccentColor,
          child: InkWell(
            onTap: () {
              onBackspace.call();
            },
            child: Center(
              child: Icon(
                Icons.backspace,
                color: defaultTextColor,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    required Key key,
    required this.onTextInput,
    required this.onBackspace,
  }) : super(key: key);
  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  void _textInputHandler(String text) => onTextInput.call(text);
  void _backspaceHandler() => onBackspace.call();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      color: Colors.white,
      child: Column(
        // <-- Column
        children: [
          buildRowOne(), // <-- Row
          buildRowTwo(), // <-- Row
          buildRowThree(), // <-- Row
          buildRowFour(),
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: '1',
            onTextInput: _textInputHandler,
            key: const Key("1"),
          ),
          TextKey(
            text: '2',
            onTextInput: _textInputHandler,
            key: const Key("2"),
          ),
          TextKey(
            text: '3',
            onTextInput: _textInputHandler,
            key: const Key("3"),
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: '4',
            onTextInput: _textInputHandler,
            key: const Key("4"),
          ),
          TextKey(
            text: '5',
            onTextInput: _textInputHandler,
            key: const Key("5"),
          ),
          TextKey(
            text: '6',
            onTextInput: _textInputHandler,
            key: const Key("6"),
          ),
        ],
      ),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: '7',
            onTextInput: _textInputHandler,
            key: const Key("7"),
          ),
          TextKey(
            text: '8',
            onTextInput: _textInputHandler,
            key: const Key("8"),
          ),
          TextKey(
            text: '9',
            onTextInput: _textInputHandler,
            key: const Key("9"),
          ),
        ],
      ),
    );
  }

  Expanded buildRowFour() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: '.',
            onTextInput: _textInputHandler,
            key: const Key("."),
          ),
          TextKey(
            text: '0',
            onTextInput: _textInputHandler,
            key: const Key("0"),
          ),
          BackspaceKey(
            onBackspace: _backspaceHandler,
            key: const Key("Bksp"),
          )
        ],
      ),
    );
  }
}

class CustomKeyboardTablet extends StatelessWidget {
  const CustomKeyboardTablet({
    required Key key,
    required this.onTextInput,
    required this.onBackspace,
  }) : super(key: key);
  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  void _textInputHandler(String text) => onTextInput.call(text);
  void _backspaceHandler() => onBackspace.call();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      color: Colors.white,
      child: Column(
        // <-- Column
        children: [
          buildRowOne(), // <-- Row
          buildRowTwo(), // <-- Row
          buildRowThree(), // <-- Row
          buildRowFour(),
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          TextKeyTablet(
            text: '1',
            onTextInput: _textInputHandler,
            key: const Key("1"),
          ),
          TextKeyTablet(
            text: '2',
            onTextInput: _textInputHandler,
            key: const Key("2"),
          ),
          TextKeyTablet(
            text: '3',
            onTextInput: _textInputHandler,
            key: const Key("3"),
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          TextKeyTablet(
            text: '4',
            onTextInput: _textInputHandler,
            key: const Key("4"),
          ),
          TextKeyTablet(
            text: '5',
            onTextInput: _textInputHandler,
            key: const Key("5"),
          ),
          TextKeyTablet(
            text: '6',
            onTextInput: _textInputHandler,
            key: const Key("6"),
          ),
        ],
      ),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          TextKeyTablet(
            text: '7',
            onTextInput: _textInputHandler,
            key: const Key("7"),
          ),
          TextKeyTablet(
            text: '8',
            onTextInput: _textInputHandler,
            key: const Key("8"),
          ),
          TextKeyTablet(
            text: '9',
            onTextInput: _textInputHandler,
            key: const Key("9"),
          ),
        ],
      ),
    );
  }

  Expanded buildRowFour() {
    return Expanded(
      child: Row(
        children: [
          TextKeyTablet(
            text: '.',
            onTextInput: _textInputHandler,
            key: const Key("."),
          ),
          TextKeyTablet(
            text: '0',
            onTextInput: _textInputHandler,
            key: const Key("0"),
          ),
          BackspaceKeyTablet(
            onBackspace: _backspaceHandler,
            key: const Key("Bksp"),
          )
        ],
      ),
    );
  }
}
