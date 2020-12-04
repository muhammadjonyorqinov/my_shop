import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _refreshProducts(BuildContext context)async{
   await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: const Text('Your products'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },)
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(context,snapshot)=> snapshot.connectionState == ConnectionState.waiting?Center(child: CircularProgressIndicator(),):RefreshIndicator(
          onRefresh: ()=>_refreshProducts(context),
          child: Consumer<Products>(
            builder: (context, productsData, Widget _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder:(_,i)=> Column(
                    children: <Widget>[
                      UserProductItem(productsData.items[i].id,productsData.items[i].title,productsData.items[i].imageUrl,productsData.deleteProduct),
                      Divider(),
                    ],
                  ) ),
            ),
          ),
        ),
      ),
    );
  }
}
