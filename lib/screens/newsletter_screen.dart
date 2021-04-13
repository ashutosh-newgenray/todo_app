import 'package:flutter/material.dart';

class NewsletterScreen extends StatefulWidget {
  static const routeName = '/newsletter';

  @override
  _NewsletterScreenState createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends State<NewsletterScreen> {
  late TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsletter"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Signup for the newsletter and unlock a theme for your lists",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black87, fontWeight: FontWeight.w300),
            ),
            Image.asset('assets/images/mail.png'),
            Container(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (String value) async {},
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black87),
                          ),
                          hintText: "Email Address",
                          hintStyle:
                              TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          'Skip',
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            side: BorderSide(width: 1, color: Colors.black87),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0))),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          'Join',
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            side: BorderSide(width: 1, color: Colors.black87),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0))),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
