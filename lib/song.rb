class Song
  attr_accessor :name
  
  attr_reader :artist, :genre
  
  @@all = []
  
  def self.all
    @@all
  end
  
  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist if artist
    self.genre = genre if genre
  end
  
  def self.destroy_all
    self.all.clear
  end
  
  def save
    @@all << self
  end
  
  def self.create(name)
    song = self.new(name)
    song.save
    song
  end
  
  def artist=(artist)
    @artist = artist
    @artist.add_song(self)
  end
  
  def genre=(genre)
    @genre = genre
    @genre.songs << self if !@genre.songs.include?(self)
  end

  def self.find_by_name(name)
    self.all.detect {|song| song.name == name}
  end

  def self.find_or_create_by_name(name)
    if self.find_by_name(name)
      self.find_by_name(name)
    else
      self.create(name)
    end
  end
  
  def self.new_from_filename(filename)
    song_elements = filename.gsub(".mp3", "").split(" - ")
    song_name = song_elements[1]
    artist_name = song_elements[0]
    genre_name = song_elements[2]
    song = self.find_or_create_by_name(song_name)
    song
  end
  
  def self.create_from_filename(filename)
    song = self.new_from_filename(filename)
    self.all << song
    song
  end
  
  describe "Song" do
  describe ".new_from_filename" do
    it "initializes a song based on the passed-in filename" do
      song = Song.new_from_filename("Thundercat - For Love I Come - dance.mp3")

      expect(song.name).to eq("For Love I Come")
      expect(song.artist.name).to eq("Thundercat")
      expect(song.genre.name).to eq("dance")
    end

    it "invokes the appropriate Findable methods so as to avoid duplicating objects" do
      artist = Artist.create("Thundercat")
      genre = Genre.create("dance")

      expect(Artist).to receive(:find_or_create_by_name).and_return(artist)
      expect(Genre).to receive(:find_or_create_by_name).and_return(genre)

      song = Song.new_from_filename("Thundercat - For Love I Come - dance.mp3")

      expect(song.artist).to be(artist)
      expect(song.genre).to be(genre)
    end
  end

  describe ".create_from_filename" do
    it "initializes and saves a song based on the passed-in filename" do
      song = Song.create_from_filename("Thundercat - For Love I Come - dance.mp3")

      expect(Song.all.last.genre.name).to eq("dance")
    end

    it "invokes .new_from_filename instead of re-coding the same functionality" do
      expect(Song).to receive(:new_from_filename).and_return(double(save: true))

      Song.create_from_filename("Thundercat - For Love I Come - dance.mp3")
    end
  end
end
end