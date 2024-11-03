import 'package:bubble/bubble.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map> messages = [];
  List<bool> showMoreFlags = [];

  @override
  void initState() {
    super.initState();
  }

  void response(String query) async {
    try {
      AuthGoogle authGoogle = await AuthGoogle(
        fileJson: "assets/dialog_flow_auth.json",
      ).build();
      DialogFlow dialogFlow =
          DialogFlow(authGoogle: authGoogle, language: Language.english);
      AIResponse aiResponse = await dialogFlow.detectIntent(query);

      var messagesList = aiResponse.getListMessage();
      String botMessage =
          "Sorry, I couldn't understand that. Can you try again?";

      if (messagesList != null && messagesList.isNotEmpty) {
        var firstMessage = messagesList[0];
        if (firstMessage.containsKey('text') &&
            firstMessage['text'] != null &&
            firstMessage['text']['text'] != null &&
            firstMessage['text']['text'].isNotEmpty) {
          botMessage = firstMessage['text']['text'][0].toString();
        }
      } else {
        botMessage = "No response from the server. Please try again later.";
      }

      setState(() {
        messages.insert(0, {"data": 0, "message": botMessage});
        showMoreFlags.insert(0, false);
      });
    } catch (e) {
      setState(() {
        messages.insert(0, {
          "data": 0,
          "message": "Error: Unable to process your request at the moment."
        });
        showMoreFlags.insert(0, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Chat',
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  'Today: ${DateFormat('Hm').format(DateTime.now())}',
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => chatTile(
                  messages[index]['message'].toString(),
                  messages[index]['data'],
                  index,
                ),
              ),
            ),
            Divider(
              height: 5,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  controller: _messageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter a message',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.send_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 40,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      messages.insert(0, {
                        "data": 1,
                        "message": _messageController.text,
                      });
                      showMoreFlags.insert(0, false);
                    });
                    response(_messageController.text);
                    _messageController.clear();
                  }
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatTile(String message, int data, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      alignment: data == 1 ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Bubble(
              radius: const Radius.circular(15),
              color: data == 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      maxLines: showMoreFlags[index] ? null : 4,
                      overflow: showMoreFlags[index]
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    if (data == 0 && message.length > 100)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              showMoreFlags[index] = !showMoreFlags[index];
                            });
                          },
                          child: Text(
                            showMoreFlags[index] ? 'Show less' : 'Show more',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
