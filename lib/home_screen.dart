import 'package:book_app/book_model.dart';
import 'package:book_app/db_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomBarShown = false;
  TextEditingController bookTitleController = TextEditingController();
  TextEditingController bookAuthorController = TextEditingController();
  TextEditingController bookCoverUrlController = TextEditingController();
  DbHelper? helper;

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Available Books',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: helper!.readAllFromDatabase(),
          builder: (context,AsyncSnapshot? snapshot) {
            if(!snapshot!.hasData) {
              return Center(
                  child: Container(
                    child: Icon(
                      Icons.menu_outlined,
                      size: 40,
                    ),
                  ),
              );
            }else {
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context , index) => Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    children: [
                      Container(
                        height: 110,
                        width: 110,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15,),
                        ),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '${snapshot.data[index]['bookCoverUrl']}',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index]['bookTitle'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Author : ${snapshot.data[index]['bookAuthor']}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: ()
                        {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  'Delete'
                              ),
                              content: Text(
                                  'Are you sure , you wanna delete this task'
                              ),
                              contentTextStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                              ),
                              actions:
                              [
                                TextButton(
                                  onPressed: ()
                                  {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: ()
                                  {
                                    setState(() {
                                      helper!.deleteFromDatabase(snapshot.data[index]['id']);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          size: 30,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context , index) => Container(
                  height: .5,
                  padding: EdgeInsetsDirectional.only(
                    start: 10,
                    end: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                ),
                itemCount: snapshot.data.length,
              );
            }
        },),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(
          isBottomBarShown?Icons.edit:Icons.add,
          size: 35,
        ),
        onPressed: ()
        {
          if(isBottomBarShown)
          {
            if(formKey.currentState!.validate()) {
              BookModel bookModel = BookModel({
                'bookTitle': bookTitleController.text,
                'bookAuthor': bookAuthorController.text,
                'bookCoverUrl': bookCoverUrlController.text,
              });
              helper!.insertToDatabase(bookModel);
              Navigator.of(context).pop();
            }else {
              return null;
            }
            setState(() {
              isBottomBarShown = false;
            });
          }else
          {
            bookTitleController.text = '';
            bookAuthorController.text = '';
            bookCoverUrlController.text = '';
            scaffoldKey.currentState!.showBottomSheet(
                  (context) => Container(
                padding: EdgeInsets.all(22,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: bookTitleController,
                        decoration: InputDecoration(
                          label: Text(
                            'Book Title',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'It must not be empty' ;
                          }else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: bookAuthorController,
                        decoration: InputDecoration(
                          label: Text(
                            'Book Author',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'It must not be empty' ;
                          }else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: bookCoverUrlController,
                        decoration: InputDecoration(
                          label: Text(
                            'Book Cover Url',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'It must not be empty' ;
                          }else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: ()
                          {
                            if(formKey.currentState!.validate()) {
                              BookModel bookModel = BookModel({
                                'bookTitle': bookTitleController.text,
                                'bookAuthor': bookAuthorController.text,
                                'bookCoverUrl': bookCoverUrlController.text,
                              });
                              helper!.insertToDatabase(bookModel);
                              Navigator.of(context).pop();
                            }else {
                              return null;
                            }
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15,),
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).closed.then((value)
            {
              setState(() {
                isBottomBarShown = false;
              });
            });
            setState(() {
              isBottomBarShown = true;
            });
          }
        },
      ),
    );
  }
}
