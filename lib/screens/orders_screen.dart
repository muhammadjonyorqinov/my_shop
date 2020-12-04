import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart' show Orders;
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/order_item.dart';
import 'package:provider/provider.dart';


class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text('Your orders'),),
      drawer: AppDrawer(),
      body:FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).fetchAndSet(),
        builder: ((context,dataSnapshot){
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else{
            if(dataSnapshot.error == null){
              return Consumer<Orders>(
                builder: ((context,orderData,child)=>ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index)=> OrderItem(orderData.orders[index]),)

              ),);
            }else{
              return Center(child: Text('Error occured'));
            }
          }
        }),
      ),
    );
  }
}
