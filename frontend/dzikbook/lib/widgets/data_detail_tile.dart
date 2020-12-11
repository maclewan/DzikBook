import 'package:flutter/material.dart';

class DataDetailTile extends StatelessWidget {
  const DataDetailTile({
    Key key,
    @required this.deviceSize,
    @required TextEditingController textController,
    @required this.title,
  })  : _textController = textController,
        super(key: key);

  final Size deviceSize;
  final TextEditingController _textController;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      trailing: Container(
          width: deviceSize.width * 0.10,
          child: TextFormField(
            controller: _textController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty ||
                  double.tryParse(value) == null ||
                  double.parse(value) <= 0) {
                return ' ';
              }
              return null;
            },
          )),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 40,
      ),
    );
  }
}
