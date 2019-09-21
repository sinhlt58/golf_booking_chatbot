import 'package:flutter/material.dart';
import 'package:golf_booking_chatbot/models/chat.dart';
import 'package:golf_booking_chatbot/services/api_service.dart';
import 'package:golf_booking_chatbot/widgets/chat_message_widget.dart';
import 'package:speech_recognition/speech_recognition.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final String _userId = 'User';
  SpeechRecognition _speech;
  bool _isAvailable = false;
  bool _isListening = false;
  String _currentLocale = '';
  final TextEditingController textEditingController = TextEditingController();
  final List<ChatMessageWidget> _messages= <ChatMessageWidget>[ChatMessageWidget(text: 'Mình có thể giúp gì cho bạn?', name: 'Bot', isMyMessage: false)];

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler((bool result) => setState(() =>_isAvailable = result));
    _speech.setRecognitionStartedHandler(() => setState(() { _isListening = true;}));
    _speech.setCurrentLocaleHandler((String locale) => setState(() => _currentLocale = locale));
    _speech.setRecognitionResultHandler((String speech) => setState(() => textEditingController.text = speech ));
    _speech.setRecognitionOnErrorHandler((){
      setState(() {_isListening = false; _isAvailable = true; textEditingController.clear();});
    });
    _speech.setRecognitionCompleteHandler(() {
      setState(() {
        _isListening = false;
      });
      _handleSubmit(textEditingController.text);  
    });
    _speech.activate().then((result) => setState(() => _isAvailable = result));
  }

  void _openSpeechChat() {
    if (_isAvailable && !_isListening){
      _speech
        .listen(locale: _currentLocale)
        .then((result) => print('$result'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              reverse: true,
              itemBuilder:(_, int index )=>_messages[index],
              itemCount: _messages.length, 
            ),
          ),
          Divider(height: 1.0,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _textComposerWidget(),
          )
        ],
      ),
    );
  }

   Widget _textComposerWidget() {
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.mic),
                onPressed: _openSpeechChat,
              ),
            ),
            Flexible(
              child: TextField(
                decoration: InputDecoration.collapsed(
                  hintText: "Enter your message",
                ),
                controller: textEditingController,
                onSubmitted: _handleSubmit,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _subHandleSubmit(textEditingController.text, false),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String text) {
    _subHandleSubmit(text, false);
  }

  void _subHandleSubmit(String text, bool isHidden) {
    if(text == null || text.trim() == '') {
      return;
    }
    textEditingController.clear();
    if(!isHidden) {
      ChatMessageWidget chatMessageWidget = ChatMessageWidget(name: _userId, text: text, isMyMessage: true);
      setState(() {
        _messages.insert(0, chatMessageWidget);
      });
    }
    chat(text).then((result) {
      for (var i = 0; i < result.botResponses.length; i++) {
        BotResponse botResponse = result.botResponses[i];
        ChatMessageWidget botChatMessageWidget = ChatMessageWidget(name: 'Bot', text: botResponse.text, isMyMessage: false);
        setState(() {
          _messages.insert(0, botChatMessageWidget);
        });
        if(i == result.botResponses.length - 1 && botResponse.actionName.startsWith('utter_utter_app')) {
          _subHandleSubmit('/client_trigger', true);
        }
      }
    });
  }
}
