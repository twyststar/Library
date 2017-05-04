require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/patron')
require('./lib/checkout')
require('./lib/book')
require('pry')
require('pg')

DB = PG.connect({:dbname => "library"})

get ('/') do
  erb(:index)
end

get('librarian_home')do
  @books = Book.all()
  erb(:librarian_home)
end
post('/patron')do
  name = params.fetch("name")
  patron = Patron.new({:name => name, :id => nil})
  patron.save()
  @books= Book.all()
  @patron = Patron.find(patron.id())
  erb(:patron)
end
end
