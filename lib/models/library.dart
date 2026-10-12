import 'library_item.dart';
import 'user.dart';

class Library {
  final List<LibraryItem> _items = [];

  void addItem(LibraryItem item) {
    _items.add(item);
  }

  List<LibraryItem> searchByTitle(String? query) {
    if (query == null) return [];
    return _items.where((item) => 
      item.title.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<LibraryItem> getItemsByAuthor(String? authorName) {
    if (authorName == null) return [];
    return _items.where((item) => item.author == authorName).toList();
  }

  List<LibraryItem> getRecentItems(DateTime? afterDate) {
    if (afterDate == null) return [];
    return _items.where((item) => 
      item.publishDate != null && item.publishDate!.isAfter(afterDate)
    ).toList();
  }

  bool borrowItem(LibraryItem item, User user, DateTime due) {
    if (item.borrower != null) {
      return false; 
    }
    item.borrower = user;
    item.dueDate = due;
    return true; 
  }

  void returnItem(LibraryItem item) {
    item.borrower = null;
    item.dueDate = null;
  }

  List<LibraryItem> get allItems => _items;
}