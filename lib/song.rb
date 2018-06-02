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
  
  def self.new_by_filename(filename)
    song_name = filename.split(" - ")[1]
    name_of_artist = filename.split(" - ")[0]
    song = Song.new(song_name)
    song.artist_name = name_of_artist
    song
  end
  
  def self.create_from_filename
    song = self.new_by_filename(filename)
    self.all << song
    song
  end
end