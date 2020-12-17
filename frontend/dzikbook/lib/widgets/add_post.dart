import 'dart:io';

import 'package:dzikbook/providers/workouts.dart';
import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  final String userImage;
  final void Function(String, File, bool, bool, Workout) addPost;

  const AddPost(this.addPost, this.userImage);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final myController = TextEditingController();
  File _image;
  Workout _workout;
  bool _workoutNotNull = false, _imageNotNull = false;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageNotNull = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _addWorkoutPlan() async {
    Workout workout = await Navigator.of(context)
        .pushNamed(WorkoutListScreen.routeName, arguments: true) as Workout;
    if (workout == null) return;
    setState(() {
      _workoutNotNull = true;
      _workout = workout;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    this._image = null;
    this._workout = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        child: Image.network(
                          this.widget.userImage,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(5),
                          child: new ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 130.0,
                            ),
                            child: new Scrollbar(
                              child: new SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: false,
                                child: SizedBox(
                                  child: new TextFormField(
                                    controller: myController,
                                    maxLines: 20,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Co słychać?',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10)),
                        ),
                        onPressed: () => {
                          if (myController.text.isNotEmpty)
                            {
                              this._imageNotNull
                                  ? this.widget.addPost(myController.text,
                                      _image, true, false, null)
                                  : this._workoutNotNull
                                      ? this.widget.addPost(myController.text,
                                          null, false, true, _workout)
                                      : this.widget.addPost(myController.text,
                                          null, false, false, null),
                            },
                          this._image = null,
                          this._workout = null,
                          this._imageNotNull = false,
                          this._workoutNotNull = false,
                          myController.clear(),
                        },
                        child: Text("OPUBLIKUJ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            )),
                        color: Color.fromRGBO(33, 150, 83, 1.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        disabledColor: Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        onPressed: this._workoutNotNull ? null : getImage,
                        child: Text(
                          "zdjęcie",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                        color: Color.fromRGBO(126, 213, 111, 1.0),
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        disabledColor: Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        onPressed: this._imageNotNull ? null : _addWorkoutPlan,
                        child: Text(
                          "trening",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                        color: Color.fromRGBO(126, 213, 111, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
