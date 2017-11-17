// what's
// sup
struct Author {
  1: string first_name,
  2: string last_name,
}

struct Book {
  // person that wrote the book
  1: Author author,
  2: i32 num_pages,
}

exception BookNotFoundException {
  1: string message,
  2: string book_name,
}

// This service does some shit
// and it does it really well
service LibraryService {
  Author get_author(
    1: Book book,
  ),

  // Finds a book
  Book get_book(
    1: string name,
  ) throws (
    1: BookNotFoundException book_not_found,
  ),
}
