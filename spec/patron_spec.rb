require('spec_helper')

describe(Patron) do
  describe('#name') do
    it('returns name')do
      test_patron = Patron.new({:name=> "Bob Ross", :id=> nil})
      expect(test_patron.name()).to(eq("Bob Ross"))
    end
  end
  describe('.all') do
    it('starts off with no patrons') do
      expect(Author.all()).to(eq([]))
    end
  end
  describe ("#id") do
    it ("sets its id when saved") do
      test_patron = Patron.new({:name=> "Bob Ross", :id=> nil})
      test_patron.save()
      expect(test_patron.id()).to(be_an_instance_of(Fixnum))
    end
  end
  describe("#save") do
    it ("lets you save author to the database") do
      test_patron = Patron.new({:name=> "Bob Ross", :id=> nil})
      test_patron.save()
      expect(Patron.all()).to(eq([test_patron]))
    end
  end
  describe("#==") do
    it("is the same patron if it has the same name") do
      test_patron = Patron.new({:name=> "Bob Ross", :id=> nil})
      test_patron.save()
      test_patron2 = Patron.new({:name=> "Bob Ross", :id=> nil})
      test_patron2.save()
      expect(test_patron).to(eq(test_patron2))
    end
  end
  describe(".find") do
    it("returns a patron by its ID") do
      test_patron = Patron.new({:name=> "Bob Ross", :id=> nil})
      test_patron.save()
      test_patron2 = Patron.new({:name=> "Betsy Ross", :id=> nil})
      test_patron2.save()
      expect(Patron.find(test_patron2.id())).to(eq(test_patron2))
    end
  end
  describe("#update") do
    it("lets you update patron in the database") do
      test_patron = Patron.new({:name=> "cool mo dee", :id=> nil})
      test_patron.save()
      test_patron.update({:name => "Peter"})
      expect(test_patron.name()).to(eq("Peter"))
    end
    it("lets you add a book to a patron") do
      test_patron = Patron.new({:name=> "cool mo dee", :id=> nil})
      test_patron.save
      oceans = Book.new({:name => "Oceans Eleven", :id => nil})
      oceans.save()
      oceans2 = Book.new({:name => "Oceans Twelve", :id => nil})
      oceans2.save()
      test_patron.update({:book_ids => [oceans.id(), oceans2.id()]})
      expect(test_patron.books()).to(eq([oceans, oceans2]))
    end
  end
  describe("#books") do
    it("returns all of the books for this patron") do
      patron = Patron.new({:name => "Brad Pitt", :id => nil})
      patron.save()
      oceans = Book.new({:name => "Oceans Eleven", :id => nil})
      oceans.save()
      oceans2 = Book.new({:name => "Oceans Twelve", :id => nil})
      oceans2.save()
      patron.update({:book_ids => [oceans.id(), oceans2.id()]})
      expect(patron.books()).to(eq([oceans, oceans2]))
    end
  end

  describe("#delete") do
    it("lets you delete a patron from the database") do
      patron = Patron.new({:name => "Brad Pitt", :id => nil})
      patron.save()
      patron2 = Patron.new({:name => "Rad Pitt", :id => nil})
      patron2.save()
      patron.delete()
      expect(Patron.all()).to(eq([patron2]))
    end
  end
end
