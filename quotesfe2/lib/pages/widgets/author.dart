import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/common/page.dart';

import 'package:url_launcher/link.dart';

import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/pages/widgets/paging.dart';


class AuthorEntry extends StatefulWidget {

  final Author _author;

  const AuthorEntry(Key? key, this._author) : super(key: key);

  @override
  State<AuthorEntry> createState() => _AuthorEntryState();
}

class _AuthorEntryState extends State<AuthorEntry> {

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text('Id: ${widget._author.id}'),

            Link(
                uri: Uri.parse('/authors/show/${widget._author.id}'),
                target: LinkTarget.blank,
                builder: (BuildContext ctx, FollowLink? openLink) {
                  return TextButton(
                    onPressed: openLink,
                    child: Text('Name: ${widget._author.name}'),
                  );
                },
              ),
            Text('Description: ${widget._author.shortDescription}')
      ],
    );
  }
}


typedef PageChangeAction = Future<AuthorsPage> Function(PageRequest);

class AuthorPageEntry extends StatefulWidget {

  final PageChangeAction _pageChangeAction;

  const AuthorPageEntry(Key? key, this._pageChangeAction) : super(key: key);

  @override
  State<AuthorPageEntry> createState() => _AuthorPageEntryState();
}

class _AuthorPageEntryState extends State<AuthorPageEntry> {

  Pagination pagination = Pagination.empty();
  List<AuthorEntry> authors = [];


 @override
  initState(){
    super.initState();
    loadPage(_currentPage);
  }

  final int _pageSize = 2;
  int _currentPage = 0;



  loadPage(int pageNo){
    setState(() {

     widget._pageChangeAction(PageRequest(_pageSize, pageNo)).then((page){
       var pages = page.info.total / _pageSize; 
        pages = (page.info.total % _pageSize == 0)? pages : pages + 1;

        authors = page.elements.map((e) => AuthorEntry(null, e)).toList(growable:true);
        pagination = Pagination(pages.toInt(), pageNo, loadPage);
        return null;
    });
  });
  }


// limit, offset, total;
   @override
  Widget build(BuildContext context) {
    

    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _searchEntityHeader('Authors'),
            ...authors,
            pagination,

          ],
    );
  }

  Text _searchEntityHeader(String text) {
    return Text(text, style: Theme.of(context).textTheme.headline4);
  }
}


