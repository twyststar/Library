class Author
  attr_reader(:name,:id)

  def initialize (attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    returned_author = DB.exec('SELECT * FROM authors;')
    authors = []
    returned_author.each() do |author|
      name = author.fetch('name')
      id = author.fetch("id").to_i()
      authors.push(Author.new({:name => name, :id => id}))
    end
    authors
  end

  def save
    result= DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==  (another_author)
    self.name().==(another_author.name())
  end

  def self.find (id)
    found_author = nil
    Author.all().each() do |author|
      if author.id().==(id)
        found_author = author
      end
    end
    found_author
  end

  def update  (attributes)
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id};")

    attributes.fetch(:book_ids, []).each() do |book_id|
    DB.exec("INSERT INTO books_authors (book_id, author_id) VALUES (#{book_id}, #{self.id()});")
  end

  def books
    author_books = []
  results = DB.exec("SELECT book_id FROM books_authors WHERE author_id = #{self.id()};")
  results.each() do |result|
    book_id = result.fetch("book_id").to_i()
    book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
    name = book.first().fetch("name")
    author_books.push(Book.new({:name => name, :id => book_id}))
  end
  author_books
  end
  end

  def delete
    DB.exec("DELETE FROM books_authors WHERE author_id = #{self.id()};")
    DB.exec("DELETE FROM authors WHERE id = #{self.id()};")
  end

end
