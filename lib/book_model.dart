class BookModel{
  int? id;
  String? bookTitle;
  String? bookAuthor;
  String? bookCoverUrl;

  BookModel(dynamic obj){
    id = obj['id'];
    bookTitle = obj['bookTitle'];
    bookAuthor = obj['bookAuthor'];
    bookCoverUrl = obj['bookCoverUrl'];
  }

  BookModel.fromMap(Map<String , dynamic> data){
    id = data['id'];
    bookTitle = data['bookTitle'];
    bookAuthor = data['bookAuthor'];
    bookCoverUrl = data['bookCoverUrl'];
  }

  Map<String , dynamic> toMap() => {'id':id , 'bookTitle':bookTitle , 'bookAuthor':bookAuthor , 'bookCoverUrl':bookCoverUrl};

}