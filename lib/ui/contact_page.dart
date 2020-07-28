import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:agendadecontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _phoneFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else
      _editedContact = Contact.fromMap(widget.contact.toMap());

    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(_editedContact.name ?? 'Novo Contato'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.phone != null &&
                _editedContact.phone.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_phoneFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 160.0,
                  height: 160.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/person.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: getImage,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome: '),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email: '),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                decoration: InputDecoration(labelText: 'Phone: '),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      onWillPop: _requestPop,
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar Alterações?'),
              content: Text('Todas as alterações serão perdidas.'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Sim'))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future getImage() async {

    final picker = ImagePicker();

        await picker.getImage(source: ImageSource.camera).then((file) {
      if (file == null) return;
      setState(() {
        _editedContact.img = file.path;
      });
    });


  }
}
