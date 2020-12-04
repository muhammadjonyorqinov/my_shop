import 'package:flutter/material.dart';
import 'package:myshop/screens/edit_product_screen.dart';


class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function _deleteHandler;

  UserProductItem(this.id,this.title,this.imageUrl,this._deleteHandler);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit, ),
              color: Theme.of(context).primaryColor,
              onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
              },),
            IconButton(icon: Icon(Icons.delete, ),
              color: Theme.of(context).errorColor,
              onPressed:()async{
              try {
               await _deleteHandler(id);
              }catch(error){
                scaffold.showSnackBar(SnackBar(
                  content: Text('Deleting Failed'),
                ));
              }
              },)
          ],
        ),
      ),
    );
  }
}
