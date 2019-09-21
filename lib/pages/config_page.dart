import 'package:flutter/material.dart';
import 'package:golf_booking_chatbot/models/config.dart';
import 'package:golf_booking_chatbot/services/local_service.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  ConfigData _configData;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() async {
    ConfigData _result = await getConfigData();
    setState(() {
      _configData = _result;
      _domainController.text = _configData.domain;
      _userIdController.text = _configData.userId;
    });
  }

  void _saveConfig() async {
    await setConfigData(_configData);
  }

  void _submit() {
    // First validate form.
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      _saveConfig();
    }
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      hintText: 'Domain',
                      labelText: 'Change domain'),
                  controller: _domainController,
                  onSaved: (String value) {
                    _configData.domain = value;
                  }),
              TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                      hintText: 'User id', 
                      labelText: 'Change user id'),
                  controller: _userIdController,
                  onSaved: (String value) {
                    _configData.userId = value;
                  }),
              Container(
                width: screenSize.width,
                child: RaisedButton(
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _submit,
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(top: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
