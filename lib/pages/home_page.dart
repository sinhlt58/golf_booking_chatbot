import 'package:flutter/material.dart';
import 'package:golf_booking_chatbot/models/search.dart';
import 'package:golf_booking_chatbot/services/api_service.dart';
import 'package:speech_recognition/speech_recognition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  SpeechRecognition _speech;
  bool _isAvailable = false;
  bool _isListening = false;
  String _currentLocale = '';
  bool _isSearching = false;
  Search _search;

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler((bool result) => setState(() =>_isAvailable = result));
    _speech.setRecognitionStartedHandler(() => setState(() { _isListening = true; _isSearching = false;}));
    _speech.setCurrentLocaleHandler((String locale) => setState(() => _currentLocale = locale));
    _speech.setRecognitionResultHandler((String speech) => setState(() => _searchController.text = speech ));
    _speech.setRecognitionOnErrorHandler((){
      setState(() {_isListening = false; _isAvailable = true; _isSearching = false; _searchController.clear();});
    });
    _speech.setRecognitionCompleteHandler(() {
      _startSearch();
    });
    _speech.activate().then((result) => setState(() => _isAvailable = result));
  }

  void _openSpeechSearch() {
    if (_isAvailable && !_isListening && !_isSearching){
      _speech
        .listen(locale: _currentLocale)
        .then((result) => print('$result'));
    }
  }

  void _onSearch() {
    if(_isListening) {
      _speech.cancel().then((_){
        if(_searchController.text.trim() != '') {
          _startSearch();
        }
      });
    } else {
      if(_searchController.text.trim() != '') {
        _startSearch();
      }
    }
  }

  void _startSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isListening = false;
      _isSearching = true;
    });
    search(_searchController.text).then((searchResult){
      setState(() {
        _search = searchResult;
        _isSearching = false;
      });        
    }).catchError((error) {
      _isListening = false; _isAvailable = true; _isSearching = false;
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xfff8faf8),
        backgroundColor: Colors.blue,
        leading: FlatButton(
          child: Icon(Icons.search, color: Colors.white,),
          onPressed: _onSearch,
        ),
        title: Container(
          child: TextField(
            style: new TextStyle(color: Colors.white),
            controller: _searchController,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Search",
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.mic, color: Colors.white,),
            onPressed: _openSpeechSearch,
          ),
        ],
      ),
      body: _isSearching
        ? Center(
          child: CircularProgressIndicator(),
        )
        : Center(
          child: _search == null ? Container()
            : Scrollbar(
              child: ListView(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only( left: 30.0, top: 30.0),
                  title: Text('Intent'),
                  subtitle: Text(_search.intent),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only( left: 30.0),
                  title: Text('Confidence'),
                  subtitle: Text('${_search.confidence}'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only( left: 30.0),
                  title: Text('Tokens'),
                  subtitle: Text('${_search.tokens.toString()}'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only( left: 30.0),
                  title: Text('Entities'),
                  subtitle: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _search.entities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Name: ${_search.entities[index].name}'),
                          Text('Value: ${_search.entities[index].value}'),
                          Text('Resolution: ${_search.entities[index].resolution}'),
                          Text('Start: ${_search.entities[index].start}'),
                          Text('End: ${_search.entities[index].end}'),
                          Text('Text: ${_search.entities[index].text}'),
                          Text('Entity: ${_search.entities[index].entity}'),
                          Text('Entity type: ${_search.entities[index].entityType}'),
                          Text('Extractor: ${_search.entities[index].extractor}'),
                          Text('Confidence: ${_search.entities[index].confidence}'),
                          Text('Name: ${_search.entities[index].name}'),
                        ],
                      );
                    }
                  )
                ),
              ],
            ),
            )
          )
    );
  }
}