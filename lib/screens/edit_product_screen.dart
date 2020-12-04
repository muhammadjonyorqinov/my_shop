import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':'',
  };

  bool isInit = true;
  bool isLoading  = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if(isInit){

      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title':_editedProduct.title,
          'description':_editedProduct.description,
          'price':_editedProduct.price.toString(),
          'imageUrl':'',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }

    }
    isInit = false;
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  Future<void> _saveForm() async{
    setState(() {
      isLoading = true;
    });

    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();
    if(_editedProduct.id != null){
      await Provider.of<Products>(context,listen: false).updateItem(_editedProduct.id,_editedProduct);
    }else{

      try{
        Provider.of<Products>(context,listen: false)
            .addProducts(_editedProduct);
      }
      catch(error){
       await showDialog(context: context,
          builder: (context)=>AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(child: Text('Ok'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),);
      }
//      finally{
//        setState(() {
//          isLoading = false;
//        });
//
//        Navigator.of(context).pop();
//      }

      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body:isLoading? Center(child: CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: value,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please Provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please Enter a price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please enter valid number';
                  }
                  if(double.parse(value)<=0){
                    return 'Please enter number greater than zero';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: value,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please Enter a description';
                  }
                  if(value.length<10){
                    return 'Should be at least 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    width: 100,
                    height: 100,
                    child: Container(
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter Url')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value){
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          price: _editedProduct.price,
                          imageUrl: value,
                          description: _editedProduct.description,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value){
                        if(value.isEmpty){
                          return 'Please Enter a url';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please Enter a valid url';
                        }
                        if(!value.endsWith('.png') && !value.endsWith('jpg') && !value.endsWith('jpeg')){
                          return 'Please Enter a valid url';
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
