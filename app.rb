require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/patron')
require('./lib/book')
require('./lib/author')
require('pry')
require('pg')

DB = PG.connect({:dbname => "library"})

get ('/') do
  erb(:index)
end

get('/librarian_home')do
  @books = Book.all()
  erb(:librarian_home)
end
post('/librarian_home')do
  @name = params.fetch('name')
  book= Book.new({:name => @name, :id => nil})
  book.save()
  @books = Book.all()
  erb(:librarian_home)
end

get('/book_edit/:id')do
  @book = Book.find(params.fetch("id").to_i)
  @books = Book.all()
  @authors = @book.authors()
  erb(:book_edit)
end

post('/author') do
  @book_id = params.fetch('book_id').to_i
  name = params.fetch('author')
  @book = Book.find(@book_id)
  author = Author.new({:name => name, :id => nil})
  author.save()
  @book.update({:author_ids => [author.id]})
  @authors = @book.authors()
  erb(:book_edit)
end
delete("/author_edit/:id") do
  @book = Book.find(params.fetch("id").to_i())
  @book.delete_auth()
  @authors = @book.authors()
  erb(:book_edit)
end

patch("/book_edit/:id") do
  name = params.fetch("name")
  @book = Book.find(params.fetch("id").to_i())
  @book.update({:name => name})
  @authors = @book.authors()
  erb(:book_edit)
end
post('/patron')do
  name = params.fetch("name")
  patron = Patron.new({:name => name, :id => nil})
  patron.save()
  @books= Book.all()
  @patron = Patron.find(patron.id())
  erb(:patron)
end
