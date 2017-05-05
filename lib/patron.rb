require('pry')
require('date')
class Patron
  attr_reader(:name, :id)
  def initialize (attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    returned_patron = DB.exec('SELECT * FROM patrons;')
    patrons = []
    returned_patron.each() do |patron|
      name = patron.fetch('name')
      id = patron.fetch("id").to_i()
      patrons.push(Patron.new({:name => name, :id => id}))
    end
    patrons
  end

  def save
    result= DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==  (another_patron)
    self.name().==(another_patron.name())
  end

  def self.find (id)
    found_patron = nil
    Patron.all().each() do |patron|
      if patron.id().==(id)
        found_patron = patron
      end
    end
    found_patron
  end

  def update  (attributes)
    due= 'May252017'


    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE patrons SET name = '#{@name}' WHERE id =  #{@id};")

    attributes.fetch(:book_ids, []).each() do |book_id|
      DB.exec("INSERT INTO checkouts (book_id, patron_id, due) VALUES (#{book_id}, #{@id}, '#{due}');")
    end
  end

  def books
    patron_books = []
    results = DB.exec("SELECT book_id FROM checkouts WHERE patron_id = #{self.id()};")
    results.each() do |result|
      book_id = result.fetch("book_id").to_i()
      book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      name = book.first().fetch("name")
      patron_books.push(Book.new({:name => name, :id => book_id}))
    end
    patron_books
  end


  def delete
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()};")
  end
end
