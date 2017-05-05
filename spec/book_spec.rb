require('spec_helper')

describe(Book) do

  describe('#name') do
    it('returns name')do
      test_book = Book.new({:name=> "cool mo dee", :id=> nil})
      expect(test_book.name()).to(eq("cool mo dee"))
    end
  end
  describe('.all') do
    it('starts off with no books') do
      expect(Book.all()).to(eq([]))
    end
  end
  describe ("#id") do
    it ("sets its id when saved") do
      test_book = Book.new({:name=> "cool mo dee", :id=> nil})
      test_book.save()
      expect(test_book.id()).to(be_an_instance_of(Fixnum))
    end
  end
  describe("#save") do
    it ("lets you save books to the database") do
      test_book = Book.new({:name=> "cool mo dee", :id=> nil})
      test_book.save()
      expect(Book.all()).to(eq([test_book]))
    end
  end
  describe("#==") do
    it("is the same book if it has the same name") do
      test_book = Book.new({:name=> "cool mo dee", :id=> nil})
      test_book2 = Book.new({:name=> "cool mo dee", :id=> nil})
      expect(test_book).to(eq(test_book2))
    end
  end
  describe(".find") do
    it("returns a book by its ID") do
      test_book = Book.new({:name=> "cool mo dee", :id=> nil})
      test_book.save()
      test_book2 = Book.new({:name=> "hippity hop", :id=> nil})
      test_book2.save()
      expect(Book.find(test_book2.id())).to(eq(test_book2))
    end
  end
  describe("#delete") do
    it("lets you delete a book from the database") do
      test_book = Book.new({:name=> "cool mo dee", :id=> nil})
      test_book.save()
      test_book2 = Book.new({:name=> "hippity hop", :id=> nil})
      test_book2.save()
      test_book.delete()
      expect(Book.all()).to(eq([test_book2]))
    end
  end
  describe("#update") do
    it("lets you update books in the database") do
      test_book = Book.new({:name=> "cool mo dee", :id=> nil})
      test_book.save()
      test_book.update({:name => "cool MO deer"})
      expect(test_book.name()).to(eq("cool MO deer"))
    end
    it("lets you add an author to a book") do
      book = Book.new({:name => "Oceans Eleven", :id => nil})
      book.save()
      george = Author.new({:name => "George Clooney", :id => nil})
      george.save()
      brad = Author.new({:name => "Brad Pitt", :id => nil})
      brad.save()
      book.update({:author_ids => [george.id(), brad.id()]})
      expect(book.authors()).to(eq([george, brad]))
    end
  end
  describe("#authors") do
    it("returns all of the authors of a particular book") do
      book = Book.new({:name => "Oceans Eleven", :id => nil})
      book.save()
      george = Author.new({:name => "George Clooney", :id => nil})
      george.save()
      brad = Author.new({:name => "Brad Pitt", :id => nil})
      brad.save()
      book.update({:author_ids => [george.id(), brad.id()]})
      expect(book.authors()).to(eq([george, brad]))
    end
  end
  describe("#delete_auth") do
    it("deletes author connections") do
      book = Book.new({:name => "Oceans Eleven", :id => nil})
      book.save()
      george = Author.new({:name => "George Clooney", :id => nil})
      george.save()
      expect(book.authors()).to(eq([]))
    end
  end
end
