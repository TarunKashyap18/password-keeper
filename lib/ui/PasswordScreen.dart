import 'package:flutter/material.dart';
import 'package:password_keeper/model/item.dart';
import 'package:password_keeper/util/database_client.dart';
import 'package:password_keeper/util/date_Formatter.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _emailController=new TextEditingController();
  final TextEditingController _passwordController=new TextEditingController();
  var db = new DatabaseHelper();
  final List<Item>_passwordList =<Item>[];

  @override
  void initState() {
    super.initState();
    _readList();
  }

  void _handelSubmit(String email ,String pswd) async {
//    _emailController.clear();
//    _passwordController.clear();

    Item item = new Item(email,pswd,dateFormatted());
    int savedItemId = await db.saveItem(item);
    Item addedItem = await db.getItem(savedItemId);
    setState(() {
      _passwordList.insert(0, addedItem);
    });

//    print("Item saved id : $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _passwordList.length,
                  itemBuilder: (_,int index){
//                    print(_passwordList[0].appName+" , ");
                      return Card(
                        color: Colors.white10,
                        child: new ListTile(
                          title:_passwordList[index],
                          onLongPress: ()=>_updateItem(_passwordList[index],index),
                          trailing: new Listener(
                            key: new Key(_passwordList[index].appName),
                            child: new Icon(Icons.remove_circle,
                            ),
                            onPointerDown: (pointerEvent)=>_deleteItem(_passwordList[index].id,index),
                          ),
                        ),
                      );
                  }
              )

          ),
          Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: "Add Item",
          child: new ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog
      ),
    );
  }
  void  _showFormDialog(){
    var alert = new AlertDialog(
      content:new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
              TextField(
                    controller: _emailController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: "Email/App Name",
                        hintText: "email/app name  goes here",
                        icon: new Icon(Icons.email)
                    ),
                  ),
              new TextField(
                    controller: _passwordController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: "Password",
                        hintText: "password goes here",
                        icon: new Icon(Icons.vpn_key)
                    ),
                  )

        ],
      ),

      actions: <Widget>[
        new FlatButton(
            onPressed: (){
              _handelSubmit(_emailController.text,_passwordController.text);
              _emailController.clear();
              _passwordController.clear();
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text("Saved")),
        new FlatButton(onPressed: ()=>Navigator.of(context, rootNavigator: true).pop('dialog'),
            child: Text("Cancel"))
      ],
    );
    showDialog(context: context,
        builder:(_){
        return alert;
        });
  }
  _readList()async{
    List listItems= await db.getItems();
    listItems.forEach((listItem){
      setState(() {
//        _passwordList.add(Item.map(listItems));
        _passwordList.add(
            Item.map(listItem)
        );
      });
    });
  }

  _deleteItem(int id,int index)async {
    debugPrint("Deleted item");
    await db.deleteItem(id);
    setState(() {
      _passwordList.removeAt(index);
    });

  }
//
//  Update list
//
  _updateItem(Item item, int index) {
    var alert= AlertDialog(
      title: Text("Update"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _emailController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Email/App Name",
                hintText: "email/app name  goes here",
                icon: new Icon(Icons.email)
            ),
          ),
          new TextField(
            controller: _passwordController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Password",
                hintText: "password goes here",
                icon: new Icon(Icons.vpn_key)
            ),
          )

        ],
      ),
//      update list
      actions: <Widget>[
        new FlatButton(
            onPressed: ()async{
              Item newItemUpdated = Item.fromMap(
                {
                  "appName":_emailController.text,
                  "data" :_passwordController.text,
                  "dateAdded": dateFormatted(),
                  "id":item.id
                }
              );
                _emailController.clear();
                _passwordController.clear();
              _handelSubmittedUpdate(index,item);//redrawing the screen
              await db.updateItem(newItemUpdated);//updating the item
              setState(() {
                _readList();//redrawing the screen with all items in db
              });
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text("Update")),
        new FlatButton(onPressed: ()=>Navigator.of(context, rootNavigator: true).pop('dialog'),
            child: Text("Cancel"))
      ],
    );
    showDialog(context:context , builder:(_){
      return alert;
    });
  }

  void _handelSubmittedUpdate(int index, Item item) {
    setState(() {
      _passwordList.removeWhere((element){
        _passwordList[index].id == item.id;
      });
    });
  }
}










