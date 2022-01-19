import 'package:flutter/material.dart';
import 'package:flutter_application/cart.dart';
import 'package:flutter_application/item.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<Item> items = [];
  List<Item> cartItems = [];
  int idCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(
              "${cartItems.length}",
              style: TextStyle(fontSize: 22),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(itemList: cartItems),
                  ));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final List<String> result = await createAlertDialog(context);
          setState(() {
            items
                .add(Item("${idCount}", result[0], double.parse(result[1]), 0));
          });
          print(idCount);
          idCount++;
        },
        child: const Icon(Icons.add),
      ),
      body: items.isEmpty == false
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, position) {
                Item currentItem = items[position];
                String itemName = currentItem.itemName;
                return Dismissible(
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      items.removeAt(position);
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
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (cartItems.contains(currentItem)) {
                                      currentItem.quantity++;
                                    } else {
                                      cartItems.add(currentItem);
                                      currentItem.quantity++;
                                    }
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${currentItem.itemName} added to cart')),
                                  );
                                },
                                child: Text("Add")),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
          : const Center(
              child: Text(
                "No Items",
                style: TextStyle(fontSize: 20),
              ),
            ),
    );
  }
}

Future<List<String>> createAlertDialog(BuildContext context) async {
  List<String> result = [];
  List<TextEditingController> _controllers =
      List.generate(2, (_) => TextEditingController());
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("New Item"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controllers[0],
                decoration: const InputDecoration(hintText: "Item Name"),
              ),
              TextField(
                controller: _controllers[1],
                decoration: const InputDecoration(hintText: "Item Price"),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(result);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  _controllers.forEach((element) {
                    result.add(element.text);
                  });
                  if (result[0] == '' || result[1] == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill out all the fields")),
                    );
                    result = [];
                  } else {
                    Navigator.of(context).pop(result);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      );
    },
  );
}
