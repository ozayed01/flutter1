import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/data/dummy_data.dart';
import 'package:shle_share/widget/book_view.dart';

class RequestedBook extends StatefulWidget {
  const RequestedBook({super.key});

  @override
  State<RequestedBook> createState() => _RequestedBookState();
}

class _RequestedBookState extends State<RequestedBook> {
  @override
  Widget build(BuildContext context) {
    setBook(String bookName) async {
      final List<Book> booklist = await queryBooks(
        bookName,
        queryType: QueryType.intitle,
        maxResults: 1,
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
      );
      return BookView(
        title: booklist[0].info.title,
        bookImg: '${booklist[0].info.imageLinks['thumbnail']}',
        id: "s",
        isFin: true,
      );
    }

    return Scaffold(
        body: GridView(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      children: [
        for (var book in BookList)
          if (book.isReq)
            FutureBuilder(
                future: setBook(book.BookName),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isFin) {
                    return BookView(
                      id: snapshot.data!.id,
                      title: snapshot.data!.title,
                      bookImg: snapshot.data!.bookImg,
                      isFin: snapshot.data!.isFin,
                    );
                  }
                  return Text('err');
                })
      ],
    ));
  }
}
