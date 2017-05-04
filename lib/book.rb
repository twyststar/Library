class Book
  attr_reader(:name,:id)

  def initialize (attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    returned_books = DB.exec('SELECT * FROM books;')
    books = []
    returned_books.each() do |book|
      name = book.fetch('name')
      id = book.fetch("id").to_i()
      books.push(Book.new({:name => name, :id => id}))
    end
    books
  end

  def save
    result= DB.exec("INSERT INTO books (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==  (another_book)
    self.name().==(another_book.name())
  end

  def self.find (id)
    found_book = nil
    Book.all().each() do |book|
      if book.id().==(id)
        found_book = book
      end
    end
    found_book
  end

  def update  (attributes)
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE books SET name = '#{@name}' WHERE id = #{@id};")

    attributes.fetch(:author_ids, []).each() do |author_id|
    DB.exec("INSERT INTO books_authors (author_id, book_id) VALUES (#{author_id}, #{self.id()});")
  end
  
  def authors
    book_authors = []
  results = DB.exec("SELECT author_id FROM books_authors WHERE book_id = #{self.id()};")
  results.each() do |result|
    author_id = result.fetch("author_id").to_i()
    author = DB.exec("SELECT * FROM authors WHERE id = #{author_id};")
    name = author.first().fetch("name")
    book_authors.push(Author.new({:name => name, :id => author_id}))
  end
  book_authors
  end
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{self.id()};")
  end

end
