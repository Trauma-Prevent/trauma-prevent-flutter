import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'results.dart';
import 'model.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trauma Prevent',
      home: TraumaPreventForm1(),
      theme: ThemeData(
        accentColor: Colors.indigo[400], // background color of card headers
        cardColor: Colors.white, // background color of fields
        backgroundColor: Colors.indigo[100], // color outside the card
        primaryColor: Colors.teal, // color of page header
        buttonColor: Colors.lightBlueAccent[100], // background color of buttons
        textTheme: TextTheme(
          button:
          TextStyle(color: Colors.deepPurple[900]), // style of button text
          //subhead: TextStyle(color: Colors.grey[800]), // style of input text
        ),
        //primaryTextTheme: TextTheme(
        //  title: TextStyle(color: Colors.lightBlue[50]), // style for headers
        //),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.indigo[400]), // style for labels
        ),
      ),
      darkTheme: ThemeData.dark(),
    );
  }
}

class TraumaPreventForm1 extends StatefulWidget {
  @override
  _TraumaPreventForm1State createState() => _TraumaPreventForm1State();
}

class _TraumaPreventForm1State extends State<TraumaPreventForm1> {
  final _model = TraumaPreventModel();

  // once the form submits, this is flipped to true, and fields can then go into autovalidate mode.
  bool _autoValidate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showMaterialonIOS = true;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Trauma Prevent"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePressed,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _resetPressed,
        ),
      ),
      body: Form(
        key: _formKey,
        child: _buildLayout()
      ),
    );
  }

  /* CARDSETTINGS FOR EACH LAYOUT */

  CardSettings _buildLayout() {
    return CardSettings.sectioned(
      showMaterialonIOS: _showMaterialonIOS,
      labelWidth: 100,
      children: <CardSettingsSection>[
        CardSettingsSection(
          showMaterialonIOS: _showMaterialonIOS,
          header: CardSettingsHeader(
            label: 'Inclusion criteria',
            showMaterialonIOS: _showMaterialonIOS,
          ),
          children: <Widget>[
            _buildCardSettingsAgePicker(),
            _buildCardSettingsSwitch_Suicidal(),
            _buildCardSettingsSwitch_FollowsUp(),
            _buildCardSettingsSwitch_PhysFamilTrauma(),
            _buildCardSettingsSwitch_Privacy()
          ],
        ),
        CardSettingsSection(
          showMaterialonIOS: _showMaterialonIOS,
          header: CardSettingsHeader(
            label: 'Actions',
            showMaterialonIOS: _showMaterialonIOS,
          ),
          children: <Widget>[
            _buildCardSettingsButton_Save(),
            _buildCardSettingsButton_Reset(),
          ],
        ),
      ],
    );
  }

  /* BUILDERS FOR EACH FIELD */

  CardSettingsNumberPicker _buildCardSettingsAgePicker(
      {TextAlign labelAlign}) {
    return CardSettingsNumberPicker(
      showMaterialonIOS: _showMaterialonIOS,
      //key: _ageKey,
      label: 'Age',
      labelAlign: labelAlign,
      initialValue: _model.age,
      min: 1,
      max: 110,
      validator: (value) {
        if (value == null) return 'Age is required.';
        return null;
      },
      onSaved: (value) => _model.age = value
    );
  }

  CardSettingsSwitch _buildCardSettingsSwitch_Suicidal() {
    return CardSettingsSwitch(
      showMaterialonIOS: _showMaterialonIOS,
      //key: _hasSuicidalKey,
      label: 'Do you have suicidal ideas?',
      labelWidth: 240.0,
      //initialValue: _model.suicidal,
      onSaved: (value) => _model.suicidal = value
    );
  }

  CardSettingsSwitch _buildCardSettingsSwitch_FollowsUp() {
    return CardSettingsSwitch(
      showMaterialonIOS: _showMaterialonIOS,
      //key: _hasFollowsUpKey,
      label: 'Do you have psychological follows up?',
      labelWidth: 240.0,
      //initialValue: _model.followsup,
      onSaved: (value) => _model.followsup = value
    );
  }

  CardSettingsSwitch _buildCardSettingsSwitch_PhysFamilTrauma() {
    return CardSettingsSwitch(
      showMaterialonIOS: _showMaterialonIOS,
      //key: _hasPhysFamilTraumaKey,
      label: 'Is the trauma related with a physical trauma done by someone in your family?',
      labelWidth: 240.0,
      //initialValue: _model.physfamiltrauma,
      onSaved: (value) => _model.physfamiltrauma = value
    );
  }

  CardSettingsSwitch _buildCardSettingsSwitch_Privacy() {
    return CardSettingsSwitch(
      showMaterialonIOS: _showMaterialonIOS,
      //key: _hasPrivacy,
      label: 'I agree to Privacy Policy',
      labelWidth: 240.0,
      //initialValue: _model.privacy,
      onSaved: (value) => _model.privacy = value
    );
  }

  CardSettingsButton _buildCardSettingsButton_Reset() {
    return CardSettingsButton(
      showMaterialonIOS: _showMaterialonIOS,
      label: 'RESET',
      isDestructive: true,
      onPressed: _resetPressed,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  CardSettingsButton _buildCardSettingsButton_Save() {
    return CardSettingsButton(
      showMaterialonIOS: _showMaterialonIOS,
      label: 'SAVE',
      onPressed: _savePressed,
    );
  }

  /* EVENT HANDLERS */

  Future _savePressed() async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      showResults(context, _model);
    } else {
      showErrors(context);
      setState(() => _autoValidate = true);
    }

  }

  void _resetPressed() {
    _formKey.currentState.reset();
  }


  // =============== UNUSED ======================


// control state only works if the field order never changes.
// to support orientation changes, we assign a unique key to each field
// if you only have one orientation, the _formKey is sufficient
//final GlobalKey<FormState> _hasSuicidalKey = GlobalKey<FormState>();
//final GlobalKey<FormState> _hasFollowsUpKey = GlobalKey<FormState>();
//final GlobalKey<FormState> _hasPhysFamilTraumaKey = GlobalKey<FormState>();
//final GlobalKey<FormState> _hasPrivacy = GlobalKey<FormState>();
//final GlobalKey<FormState> _ageKey = GlobalKey<FormState>();

// -------------------------------------------------------------------

// final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _typeKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _descriptionlKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _hobbiesKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _coatKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _maneKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _spotKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _heightKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _weightKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _timeKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _priceKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
// final GlobalKey<FormState> _sliderKey = GlobalKey<FormState>();


//CardSettings _buildLandscapeLayout() {
//  return CardSettings.sectioned(
//    showMaterialonIOS: _showMaterialonIOS,
//    labelPadding: 12.0,
//    children: <CardSettingsSection>[
//      CardSettingsSection(
//        showMaterialonIOS: _showMaterialonIOS,
//        header: CardSettingsHeader(
//          label: 'Bio',
//          showMaterialonIOS: _showMaterialonIOS,
//        ),
//        children: <Widget>[
//          //_buildCardSettingsText_Name(),
//          CardFieldLayout(
//            <Widget>[
//              //_buildCardSettingsListPicker_Type(),
//              //_buildCardSettingsNumberPicker(labelAlign: TextAlign.right),
//            ],
//            flexValues: [2, 1],
//          ),
//          //_buildCardSettingsParagraph(3),
//          //_buildCardSettingsMultiselect(),
//        ],
//      ),
//      CardSettingsSection(
//        showMaterialonIOS: _showMaterialonIOS,
//        header: CardSettingsHeader(
//          label: 'Security',
//          showMaterialonIOS: _showMaterialonIOS,
//        ),
//        children: <Widget>[
//          CardFieldLayout(<Widget>[
//            //_buildCardSettingsEmail(),
//            //_buildCardSettingsPassword(),
//          ]),
//        ],
//      ),
//      CardSettingsSection(
//        showMaterialonIOS: _showMaterialonIOS,
//        header: CardSettingsHeader(
//          label: 'Colors',
//          showMaterialonIOS: _showMaterialonIOS,
//        ),
//        children: <Widget>[
//          CardFieldLayout(<Widget>[
//            //_buildCardSettingsColorPicker_Coat(),
//            //_buildCardSettingsColorPicker_Mane(),
//          ]),
//          CardFieldLayout(<Widget>[
//            _buildCardSettingsSwitch_Suicidal(),
//            _buildCardSettingsSwitch_FollowsUp(),
//          //_buildCardSettingsColorPicker_Spot(),
//          ]),
//        ],
//      ),
//      CardSettingsSection(
//        showMaterialonIOS: _showMaterialonIOS,
//        header: CardSettingsHeader(
//          label: 'Size',
//          showMaterialonIOS: _showMaterialonIOS,
//        ),
//        children: <Widget>[
//          CardFieldLayout(<Widget>[
//            //_buildCardSettingsDouble_Height(),
//            //_buildCardSettingsInt_Weight(),
//          ]),
//        ],
//      ),
//      CardSettingsSection(
//        showMaterialonIOS: _showMaterialonIOS,
//        header: CardSettingsHeader(
//          label: 'First Show',
//          showMaterialonIOS: _showMaterialonIOS,
//        ),
//        children: <Widget>[
//          //_buildCardSettingsInstructions(),
//          CardFieldLayout(<Widget>[
//            //_buildCardSettingsDatePicker(),
//            //_buildCardSettingsTimePicker(),
//          ]),
//          CardFieldLayout(<Widget>[
//            //_buildCardSettingsCurrency(),
//            //_buildCardSettingsPhone(),
//          ]),
//          //_buildCardSettingsDouble_Slider(),
//        ],
//      ),
//      CardSettingsSection(
//        showMaterialonIOS: _showMaterialonIOS,
//        header: CardSettingsHeader(
//          label: 'Actions',
//          showMaterialonIOS: _showMaterialonIOS,
//        ),
//        children: <Widget>[
//          CardFieldLayout(<Widget>[
//            _buildCardSettingsButton_Save(),
//            _buildCardSettingsButton_Reset(),
//          ]),
//        ],
//      ),
//    ],
//  );
// }

  //  CardSettingsPassword _buildCardSettingsPassword() {
  //    return CardSettingsPassword(
  //      showMaterialonIOS: _showMaterialonIOS,
  //     labelWidth: 150.0,
  //     key: _passwordKey,
  //     icon: Icon(Icons.lock),
  //     initialValue: _model.password,
  //     autovalidate: _autoValidate,
  //     validator: (value) {
  //       if (value == null) return 'Password is required.';
  //       if (value.length <= 6) return 'Must be more than 6 characters.';
  //     return null;
  //      },
  //     onSaved: (value) => _model.password = value,
  //     onChanged: (value) {
  //       setState(() {
  //       _model.password = value;
  //      });
  //      _showSnackBar('Password', value);
  //    },
  //  );
  // }

  // CardSettingsEmail _buildCardSettingsEmail() {
  //  return CardSettingsEmail(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    labelWidth: 150.0,
  //    key: _emailKey,
  //    icon: Icon(Icons.person),
  //    initialValue: _model.email,
  //    autovalidate: _autoValidate,
  //    validator: (value) {
  //      if (value == null || value.isEmpty) return 'Email is required.';
  //      if (!value.contains('@'))
  //        return "Email not formatted correctly."; // use regex in real application
  //      return null;
  //    },
  //    onSaved: (value) => _model.email = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.email = value;
  //      });
  //      _showSnackBar('Email', value);
  //    },
  //  );
  // }

  // CardSettingsPhone _buildCardSettingsPhone() {
  //  return CardSettingsPhone(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _phoneKey,
  //    label: 'Box Office',
  //    initialValue: _model.boxOfficePhone,
  //    autovalidate: _autoValidate,
  //    validator: (value) {
  //      if (value != null && value.toString().length != 10)
  //        return 'Incomplete number';
  //      return null;
  //    },
  //    onSaved: (value) => _model.boxOfficePhone = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.boxOfficePhone = value;
  //      });
  //      _showSnackBar('Box Office', value);
  //    },
  //  );
  // }

  // CardSettingsCurrency _buildCardSettingsCurrency() {
  //  return CardSettingsCurrency(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _priceKey,
  //    label: 'Ticket Price',
  //    initialValue: _model.ticketPrice,
  //    autovalidate: _autoValidate,
  //    validator: (value) {
  //      if (value != null && value > 100) return 'No scalpers allowed!';
  //      return null;
  //    },
  //    onSaved: (value) => _model.ticketPrice = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.ticketPrice = value;
  //      });
  //      _showSnackBar('Ticket Price', value);
  //    },
  //  );
  // }

  // CardSettingsTimePicker _buildCardSettingsTimePicker() {
  //  return CardSettingsTimePicker(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _timeKey,
  //    icon: Icon(Icons.access_time),
  //    label: 'Time',
  //    initialValue: TimeOfDay(
  //        hour: _model.showDateTime.hour,
  //        minute: _model.showDateTime.minute),
  //    onSaved: (value) => _model.showDateTime =
  //        updateJustTime(value, _model.showDateTime),
  //    onChanged: (value) {
  //      setState(() {
  //        _model.showDateTime =
  //            updateJustTime(value, _model.showDateTime);
  //      });
  //      _showSnackBar('Show Time', value);
  //    },
  //  );
  // }

  // CardSettingsDatePicker _buildCardSettingsDatePicker() {
  //  return CardSettingsDatePicker(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _dateKey,
  //    justDate: true,
  //    icon: Icon(Icons.calendar_today),
  //    label: 'Date',
  //    initialValue: _model.showDateTime,
  //    onSaved: (value) => _model.showDateTime =
  //        updateJustDate(value, _model.showDateTime),
  //    onChanged: (value) {
  //      setState(() {
  //        _model.showDateTime = value;
  //      });
  //      _showSnackBar(
  //          'Show Date', updateJustDate(value, _model.showDateTime));
  //    },
  //  );
  // }

  // CardSettingsInstructions _buildCardSettingsInstructions() {
  //   return CardSettingsInstructions(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    text: 'This is when this little horse got her big break',
  //  );
  // }

  // CardSettingsInt _buildCardSettingsInt_Weight() {
  //  return CardSettingsInt(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _weightKey,
  //    label: 'Weight',
  //    unitLabel: 'lbs',
  //    initialValue: _model.weight,
  //    autovalidate: _autoValidate,
  //    validator: (value) {
  //      if (value != null) {
  //        if (value > 70) return 'You won\'t fly at the weight.';
  //        if (value < 10) return 'Cmon, you are not a feather.';
  //      }
  //      return null;
  //    },
  //    onSaved: (value) => _model.weight = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.weight = value;
  //      });
  //      _showSnackBar('Weight', value);
  //    },
  //  );
  // }

  // CardSettingsDouble _buildCardSettingsDouble_Height() {
  //  return CardSettingsDouble(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _heightKey,
  //    label: 'Height',
  //    unitLabel: 'feet',
  //    decimalDigits: 2,
  //    initialValue: _model.height,
  //    onSaved: (value) => _model.height = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.height = value;
  //      });
  //      _showSnackBar('Height', value);
  //    },
  //  );
  // }

  // CardSettingsColorPicker _buildCardSettingsColorPicker_Spot() {
  //  return CardSettingsColorPicker(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _spotKey,
  //    label: 'Spot',
  //    pickerType: CardSettingsColorPickerType.block,
  //    initialValue: intelligentCast<Color>(_model.spotColor),
  //    visible: _model.hasSpots,
  //    onSaved: (value) => _model.spotColor = colorToString(value),
  //    onChanged: (value) {
  //      setState(() {
  //        _model.type = colorToString(value);
  //      });
  //      _showSnackBar('Spot', value);
  //    },
  //  );
  // }

  // CardSettingsColorPicker _buildCardSettingsColorPicker_Mane() {
  //  return CardSettingsColorPicker(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _maneKey,
  //    label: 'Mane',
  //    initialValue: intelligentCast<Color>(_model.maneColor),
  //    autovalidate: _autoValidate,
  //    pickerType: CardSettingsColorPickerType.material,
  //    validator: (value) {
  //      if (value.computeLuminance() > .7) return 'This color is too light.';
  //      return null;
  //    },
  //    onSaved: (value) => _model.maneColor = colorToString(value),
  //    onChanged: (value) {
  //      setState(() {
  //        _model.maneColor = colorToString(value);
  //      });
  //      _showSnackBar('Mane', value);
  //    },
  //  );
  // }

  // CardSettingsColorPicker _buildCardSettingsColorPicker_Coat() {
  //  return CardSettingsColorPicker(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _coatKey,
  //    label: 'Coat',
  //    initialValue: intelligentCast<Color>(_model.coatColor),
  //    autovalidate: _autoValidate,
  //    validator: (value) {
  //      if (value.computeLuminance() < .3)
  //        return 'This color is not cheery enough.';
  //      return null;
  //    },
  //    onSaved: (value) => _model.coatColor = colorToString(value),
  //    onChanged: (value) {
  //      setState(() {
  //        _model.coatColor = colorToString(value);
  //      });
  //      _showSnackBar('Coat', value);
  //    },
  //  );
  // }

  // CardSettingsMultiselect _buildCardSettingsMultiselect() {
  //  return CardSettingsMultiselect(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _hobbiesKey,
  //    label: 'Hobbies',
  //    initialValues: _model.hobbies,
  //    options: allHobbies,
  //    autovalidate: _autoValidate,
  //    validator: (List<String> value) {
  //      if (value == null || value.isEmpty)
  //        return 'You must pick at least one hobby.';
  //
  //      return null;
  //    },
  //    onSaved: (value) => _model.hobbies = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.hobbies = value;
  //      });
  //      _showSnackBar('Hobbies', value);
  //    },
  //  );
  // }

  // CardSettingsParagraph _buildCardSettingsParagraph(int lines) {
  //  return CardSettingsParagraph(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _descriptionlKey,
  //    label: 'Description',
  //    initialValue: _model.description,
  //    numberOfLines: lines,
  //    onSaved: (value) => _model.description = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.description = value;
  //      });
  //      _showSnackBar('Description', value);
  //    },
  //  );
  // }

  // CardSettingsListPicker _buildCardSettingsListPicker_Type() {
  //  return CardSettingsListPicker(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _typeKey,
  //    label: 'Type',
  //    initialValue: _model.type,
  //    hintText: 'Select One',
  //    autovalidate: _autoValidate,
  //    options: <String>['Earth', 'Unicorn', 'Pegasi', 'Alicorn'],
  //    values: <String>['E', 'U', 'P', 'A'],
  //    validator: (String value) {
  //      if (value == null || value.isEmpty) return 'You must pick a type.';
  //      return null;
  //    },
  //    onSaved: (value) => _model.type = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.type = value;
  //      });
  //      _showSnackBar('Type', value);
  //    },
  //  );
  // }

  // CardSettingsText _buildCardSettingsText_Name() {
  //  return CardSettingsText(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _nameKey,
  //    label: 'Name',
  //    hintText: 'something cute...',
  //    initialValue: _model.name,
  //    requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
  //    autovalidate: _autoValidate,
  //    validator: (value) {
  //      if (value == null || value.isEmpty) return 'Name is required.';
  //      return null;
  //    },
  //    onSaved: (value) => _model.name = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.name = value;
  //      });
  //      _showSnackBar('Name', value);
  //    },
  //  );
  // }

  // CardSettingsSlider _buildCardSettingsDouble_Slider() {
  //  return CardSettingsSlider(
  //    showMaterialonIOS: _showMaterialonIOS,
  //    key: _sliderKey,
  //    label: 'Rating',
  //    initialValue: _model.rating,
  //    autovalidate: _autoValidate,
  //    validator: (double value) {
  //      if (value == null) return 'You must pick a rating.';
  //      return null;
  //    },
  //    onSaved: (value) => _model.rating = value,
  //    onChanged: (value) {
  //      setState(() {
  //        _model.rating = value;
  //      });
  //      _showSnackBar('Rating', value);
  //    },
  //  );
  // }

  // void _showSnackBar(String label, dynamic value) {
  //  _scaffoldKey.currentState.removeCurrentSnackBar();
  //  _scaffoldKey.currentState.showSnackBar(
  //    SnackBar(
  //      duration: Duration(seconds: 1),
  //      content: Text(label + ' = ' + value.toString()),
  //    ),
  //  );
  // }
}
