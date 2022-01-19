import 'package:flutter/material.dart';
import 'package:flutter_application/item.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key, required this.itemList}) : super(key: key);

  final List<Item> itemList;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double calculate() {
    double total = 0;
    for (int i = 0; i < widget.itemList.length; i++) {
      total += widget.itemList[i].price * widget.itemList[i].quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: widget.itemList.length,
          itemBuilder: (context, position) {
            Item currentItem = widget.itemList[position];
            String itemName = currentItem.itemName;
            return Dismissible(
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  widget.itemList.removeAt(position);
                  currentItem.quantity = 0;
                });
              },
              key: Key(currentItem.id),
              child: Container(
                child: Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ' ${currentItem.itemName}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' ${currentItem.price} TL',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "Quantity: ${currentItem.quantity}",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.blue,
          alignment: Alignment.bottomCenter,
          height: 48,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.all(65)),
              Center(
                child: Text("Total: ${calculate()}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
