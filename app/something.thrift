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
