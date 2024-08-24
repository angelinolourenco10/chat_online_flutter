import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(MyApp());
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final TextEditingController controller = TextEditingController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat App",
      theme: ThemeData(
          primarySwatch: Colors.purple,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.purple, foregroundColor: Colors.white)),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat App"),
          centerTitle: true,
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message =
                      messages[index].data() as Map<String, dynamic>;
                      return ChatMessage(
                        text: message['text'] ?? '',
                        imgUrl: message['imgUrl'],
                        userName: message['userName'],
                        userPhotoUrl: message['userPhotoUrl'],
                      );
                    },
                  );
                },
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  const TextComposer({super.key});

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposed = false;
  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;
    await _ensureLoggedIn();
    _sendMessage(text: text);
    _controller.clear(); // Limpa o campo de texto após enviar a mensagem
    setState(() {
      _isComposed = false; // Reseta o estado do botão de envio
    });
  }

  @override
  Widget build(BuildContext context) {
    ImagePicker imagePicker = ImagePicker();
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
            border: Border(top: BorderSide(color: Colors.green)))
            : null,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async {
                await _ensureLoggedIn();
                final XFile? imgFile =
                await imagePicker.pickImage(source: ImageSource.camera);
                if (imgFile == null) return;
                final File file = File(imgFile.path);
                final String fileName = googleSignIn.currentUser!.id +
                    DateTime.now().microsecondsSinceEpoch.toString();
                final UploadTask task = FirebaseStorage.instance
                    .ref()
                    .child(fileName)
                    .putFile(file);

                final TaskSnapshot snapshot = await task;
                final String downloadUrl = await snapshot.ref.getDownloadURL();
                _sendMessage(imgUrl: downloadUrl, text: '');
              },
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration:
                InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposed = text.isNotEmpty;
                  });
                },
                onSubmitted: _handleSubmitted,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                child: Text("Enviar"),
                onPressed: _isComposed
                    ? () {
                  _handleSubmitted(_controller.text);
                }
                    : null,
              )
                  : IconButton(
                onPressed: _isComposed
                    ? () {
                  _handleSubmitted(_controller.text);
                }
                    : null,
                icon: Icon(Icons.send),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _ensureLoggedIn() async {
  GoogleSignInAccount? user = googleSignIn.currentUser;

  if (user == null) {
    user = await googleSignIn.signInSilently();
  }

  if (user == null) {
    try {
      user = await googleSignIn.signIn();
    } catch (error) {
      print('Erro ao fazer login: $error');
      return;
    }
  }

  if (user != null && auth.currentUser == null) {
    try {
      GoogleSignInAuthentication credentials = await user.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );

      await auth.signInWithCredential(credential);
    } catch (error) {
      print('Erro ao fazer login com credenciais do Google: $error');
    }
  }
}

void _sendMessage({required String text, String? imgUrl}) async {
  User? user = auth.currentUser;

  if (user != null) {
    await firestore.collection('messages').add({
      'text': text,
      'imgUrl': imgUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid,
      'userName': user.displayName ?? 'Anônimo',
      'userPhotoUrl': user.photoURL ?? '',
    });
  } else {
    print('User is not logged in.');
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String? imgUrl;
  final String userName;
  final String userPhotoUrl;

  const ChatMessage({
    super.key,
    required this.text,
    this.imgUrl,
    required this.userName,
    required this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userPhotoUrl),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: Theme.of(context).textTheme.subtitle1),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
                if (imgUrl != null && imgUrl!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Image.network(imgUrl!),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
