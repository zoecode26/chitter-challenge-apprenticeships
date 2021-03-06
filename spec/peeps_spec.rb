require 'peeps'

describe Peeps do

  describe '#all' do
    it 'returns list of all names and messages' do
      add_row_to_test_database
      expect(Peeps.all.first.message).to eq("This is a peep!")
    end
  end

  describe '#add' do
    before :each do
      Peeps.add('This is a new test peep')
    end

    it 'adds message to peeps db table' do
      expect(Peeps.all.first.message).to eq("This is a new test peep")
    end

    it 'adds date to peeps db table' do
      expect(Peeps.all.first.date).to eq(Time.now.strftime("%Y-%m-%d"))
    end
  end

  describe '#filter' do
    it 'displays all peeps containing a certain search phrase' do
      Peeps.add("This is peep one")
      Peeps.add("This is peep two")

      result = Peeps.filter("one")

      expect(result.first.message).to eq("This is peep one")
    end
  end

  describe '.delete' do
    it 'deletes the given bookmark' do
      peep = Peeps.add('peep')
      Peeps.delete(id: peep.id)

      expect(Peeps.all.length).to eq 0
    end
  end

  describe '.update' do
    it 'updates the peep message' do
      peep = Peeps.add('Old message')
      updated_peep = Peeps.update(id: peep.id, message: 'New Message', date: Time.now.strftime("%Y-%m-%d"))

      expect(updated_peep).to be_a Peeps
      expect(updated_peep.id).to eq peep.id
      expect(updated_peep.message).to eq 'New Message'
      expect(updated_peep.date).to eq Time.now.strftime("%Y-%m-%d")
    end
  end

  describe '.find' do
    it 'returns the requested peep object' do
      peep = Peeps.add('This is the message to find')

      result = Peeps.find(id: peep.id)

      expect(result).to be_a Peeps
      expect(result.id).to eq peep.id
      expect(result.message).to eq 'This is the message to find'
    end
  end

  describe '#comments' do
    it 'returns a list of comments on the peep' do
      peep = Peeps.add('Peep to comment on')
      DatabaseConnection.query("INSERT INTO comments (id, text, peep_id) VALUES(1, 'Test comment', #{peep.id})")

      comment = peep.comments.first

      expect(comment['text']).to eq 'Test comment'
    end
  end

end
