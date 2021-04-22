import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import '../../utils/general.dart';
import 'state.dart';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

Widget buildView(
  AddPhonePageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);
  return _MainBody();
}

class _MainBody extends StatefulWidget {
  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#F2F6FA"),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/background_lines_top.png",
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/background_lines_bottom.png",
              fit: BoxFit.contain,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              leadingWidth: 70.0,
              automaticallyImplyLeading: false,
              leading: InkWell(
                child: Image.asset("images/back_button.png"),
                onTap: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Add Phone",
                      style: TextStyle(fontSize: 32),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "1.Prizes are sent via SMS.",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "2.We don't share or you. Ever.",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 50),
                    _InnerPart(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InnerPart extends StatefulWidget {
  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  final _formKey = GlobalKey<FormState>();
  String emailValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CountryPickerDropdown(context: context),
            SizedBox(height: 180),
            ButtonTheme(
              minWidth: 300.0,
              height: 48.0,
              child: RaisedButton(
                textColor: Colors.white,
                elevation: 0,
                color: HexColor("#6092DC"),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  _onSubmit(_formKey, emailValue);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(31.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _onSubmit(formKey, emailValue) async {
  if (formKey.currentState.validate()) {
    try {
      QueryResult result =
          await BaseGraphQLClient.instance.forgotPassword(emailValue);
      if (result.hasException) print(result.exception);
    } catch (e) {
      print(e);
    }
  }
}

class _CountryPickerDropdown extends StatefulWidget {
  final BuildContext context;

  _CountryPickerDropdown({Key key, this.context}) : super(key: key);

  @override
  __CountryPickerDropdownState createState() => __CountryPickerDropdownState();
}

class __CountryPickerDropdownState extends State<_CountryPickerDropdown> {
  double dropdownButtonWidth;
  double dropdownItemWidth;
  String phoneValue = "";

  @override
  void initState() {
    super.initState();
    dropdownButtonWidth = MediaQuery.of(widget.context).size.width * 0.34;
    dropdownItemWidth = MediaQuery.of(widget.context).size.width / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: dropdownButtonWidth,
          child: CountryPickerDropdown(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            itemHeight: null,
            isDense: false,
            icon: Container(
              padding: EdgeInsets.only(left: 0, top: 8, right: 5, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Icon(Icons.keyboard_arrow_down),
            ),
            selectedItemBuilder: (Country country) =>
                _buildDropdownSelectedItemBuilder(country),
            itemBuilder: (Country country) =>
                _buildDropdownItem(country, dropdownItemWidth),
            initialValue: 'US',
            onValuePicked: (Country country) {
              print("${country.name}");
            },
          ),
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (String value) {
              setState(() {
                phoneValue = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Add Phone",
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.black26,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}

Widget _buildDropdownSelectedItemBuilder(Country country) {
  return Container(
    padding: EdgeInsets.only(left: 10, top: 10, right: 0, bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
    ),
    child: CountryPickerUtils.getDefaultFlagImage(country),
  );
}

Widget _buildDropdownItem(Country country, double dropdownItemWidth) {
  return SizedBox(
    width: dropdownItemWidth,
    child: Row(
      children: [
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Expanded(child: Text("+${country.phoneCode}(${country.isoCode})")),
      ],
    ),
  );
}
