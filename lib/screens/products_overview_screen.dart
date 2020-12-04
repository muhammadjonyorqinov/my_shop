import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/Badge.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/products_grid.dart';
import 'package:http/http.dart' as http;

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool isInit = true;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
//    Future.delayed(Duration.zero).then((_){
//      Provider.of<Products>(context).fetchAndSetProducts();
//    });
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(isInit){
      setState(() {
        isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_){
        setState(() {
          isLoading = false;
        });

      });
    }
    isInit = false;
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                productsContainer.showFavoritesOnly();
              } else {
                productsContainer.showAll();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
          builder: (_, cart, ch)=> Badge(
              child: ch,
            value: cart.itemCount.toString(),
            ),
            child: IconButton( icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
    ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:isLoading? Center(
        child: CircularProgressIndicator(),
      ):ProductsGrid(),
    );
  }
}
