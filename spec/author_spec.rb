require('spec_helper')

describe(Author) do

  describe('#name') do
    it('returns name')do
      test_author = Author.new({:name=> "Tom Sawyer", :id=> nil})
      expect(test_author.name()).to(eq("Tom Sawyer"))
    end
  end
  describe('.all') do
    it('starts off with no authors') do
      expect(Author.all()).to(eq([]))
    end
  end
  describe ("#id") do
    it ("sets its id when saved") do
      test_author = Author.new({:name=> "Tom Sawyer", :id=> nil})
      test_author.save()
      expect(test_author.id()).to(be_an_instance_of(Fixnum))
    end
  end
  describe("#save") do
    it ("lets you save author to the database") do
      test_author = Author.new({:name=> "Tom Sawyer", :id=> nil})
      test_author.save()
      expect(Author.all()).to(eq([test_author]))
    end
  end
  describe("#==") do
    it("is the same author if it has the same name") do
      test_author = Author.new({:name=> "Tom Sawyer", :id=> nil})
      test_author2 = Author.new({:name=> "Tom Sawyer", :id=> nil})
      expect(test_author).to(eq(test_author2))
    end
  end
  describe(".find") do
    it("returns a author by its ID") do
      test_author = Author.new({:name=> "cool mo dee", :id=> nil})
      test_author.save()
      test_author2 = Author.new({:name=> "hippity hop", :id=> nil})
      test_author2.save()
      expect(Author.find(test_author2.id())).to(eq(test_author2))
    end
  end
  describe("#update") do
    it("lets you update author in the database") do
      test_author = Author.new({:name=> "cool mo dee", :id=> nil})
      test_author.save()
      test_author.update({:name => "Peter"})
      expect(test_author.name()).to(eq("Peter"))
    end
    it("lets you add an book to an author") do
      author = Author.new({:name => "Brad Pitt", :id => nil})
      author.save()
      oceans = Book.new({:name => "Oceans Eleven", :id => nil})
      oceans.save()
      oceans2 = Book.new({:name => "Oceans Twelve", :id => nil})
      oceans2.save()
      author.update({:book_ids => [oceans.id(), oceans2.id()]})
      expect(author.books()).to(eq([oceans, oceans2]))
    end
  end
  describe("#books") do
    it("returns all of the books by a particular author") do
      author = Author.new({:name => "Brad Pitt", :id => nil})
      author.save()
      oceans = Book.new({:name => "Oceans Eleven", :id => nil})
      oceans.save()
      oceans2 = Book.new({:name => "Oceans Twelve", :id => nil})
      oceans2.save()
      author.update({:book_ids => [oceans.id(), oceans2.id()]})
      expect(author.books()).to(eq([oceans, oceans2]))
    end
  end
  describe("#delete") do
    it("lets you delete a author from the database") do
      test_author= Author.new({:name=> "Tom Sawyer", :id=> nil})
      test_author.save()
      test_author2 = Author.new({:name=> "Ernest Hemingway", :id=> nil})
      test_author2.save()
      test_author.delete()
      expect(Author.all()).to(eq([test_author2]))
    end
  end
end
