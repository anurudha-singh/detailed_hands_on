import 'package:flutter/material.dart';

class PaginationList extends StatefulWidget {
  static String routeName = '/pagination_list';
  const PaginationList({super.key});

  @override
  State<PaginationList> createState() => _PaginationListState();
}

class _PaginationListState extends State<PaginationList> {
  /*
1.Create a ScrollController to check the detection of scroll to bottom
2. Create a list of items to show in the listview
3. Create a boolean to check if we are loading more items
4. In initstate add a listener to the scrollcontroller to check if we are at the bottom
5. If we are at the bottom, call a function to load more items
6. In the load more items function, set loading to true, add more items to the list after a delay, set loading to false and call setstate
7. In the build method, create a listview builder with the scrollcontroller
8. In the itembuilder, check if the index is equal to the length of the list, if it is, show a loading indicator, else show the item
9. In the dispose method, dispose the scrollcontroller
*/
  ScrollController _scrollController = ScrollController();
  List<int> items = List.generate(20, (index) => index);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreItems();
      }
    });
  }

  void _loadMoreItems() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    List<int> newItems = List.generate(20, (index) => items.length + index);
    setState(() {
      items.addAll(newItems);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagination List')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListTile(title: Text('Item ${items[index]}'));
        },
      ),
    );
  }
}
