typedef string Email

const i32 BOOK_LIMIT = 500

// The section a book should be in
enum Category {
  // This could be literally anything
  NONFICTION = 0,
  SCIFI = 1,
  FANTASY = 2,
  MYSTERY = 3,
}

// what's
// sup
struct Author {
  1: string first_name,
  2: string last_name,
  3: Email email,
  4: optional Address address,
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
  something.Author get_author(
    // Find the author for this book
    1: Book book,
  ),

  // Finds a book
  Book get_book(
    1: string name,
  ) throws (
    1: BookNotFoundException book_not_found,
  ),
}
