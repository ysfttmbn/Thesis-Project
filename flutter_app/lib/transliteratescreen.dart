import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batak Transliterator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TransliterateScreenWidget(),
    );
  }
}

class TransliterateScreenWidget extends StatefulWidget {
  const TransliterateScreenWidget({Key? key}) : super(key: key);

  @override
  _TransliterateScreenWidgetState createState() =>
      _TransliterateScreenWidgetState();
}

class _TransliterateScreenWidgetState extends State<TransliterateScreenWidget> {
  TextEditingController _inputController = TextEditingController();
  String _transliteratedText = '';
  String _tokenizedText = '';
  String _errorMessage = '';

  Future<void> _translateText() async {
    String inputText = _inputController.text;

    // Check if the input text exceeds 10 words
    List<String> words = inputText.split(RegExp(r'\s+'));
    if (words.length > 10) {
      setState(() {
        _errorMessage = 'Teks tidak boleh lebih dari 10 kata.';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/transliterate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'text': inputText}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        _transliteratedText = responseBody['result'];
        _tokenizedText = responseBody['tokens'].join('-');
        _errorMessage = ''; // Clear any previous error message
      });
    } else {
      setState(() {
        _transliteratedText = 'Error: ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        automaticallyImplyLeading: false,
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final screenWidth = constraints.maxWidth;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Translator Aksara Batak',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Layanan penerjemah bahasa batak ke aksara',
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: BoxConstraints(
                    maxWidth: 750,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 12),
                          child: Text(
                            'Masukkan teks bahasa batak',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _inputController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Masukkan teks...',
                          ),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: BoxConstraints(
                    maxWidth: 750,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, -1),
                          child: Text(
                            'Tokenisasi :',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF14181B),
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 12),
                          child: Text(
                            _tokenizedText.isEmpty ? '' : _tokenizedText,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, -1),
                          child: Text(
                            'Aksara Batak Toba :',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF14181B),
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 12),
                          child: Text(
                            _transliteratedText.isEmpty
                                ? ''
                                : _transliteratedText,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: ElevatedButton(
                  onPressed: _translateText,
                  child: Text('Terjemahkan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
