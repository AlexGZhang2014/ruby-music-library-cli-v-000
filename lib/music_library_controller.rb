class MusicLibraryController
  def initialize(path = "./db/mp3s")
    MusicImporter.new(path).import
  end
  
  def call
    puts "Welcome to your music library!"
    puts "To list all of your songs, enter 'list songs'."
    puts "To list all of the artists in your library, enter 'list artists'."
    puts "To list all of the genres in your library, enter 'list genres'."
    puts "To list all of the songs by a particular artist, enter 'list artist'."
    puts "To list all of the songs of a particular genre, enter 'list genre'."
    puts "To play a song, enter 'play song'."
    puts "To quit, type 'exit'."
    puts "What would you like to do?"
    
    input = gets.strip
    
    list_songs if input == "list songs"
    
    call unless input == "exit"
  end
  
  def list_songs
    songs = Song.all.uniq.sort {|a, b| a.name <=> b.name}
    songs.each_with_index do |song, index|
      puts "#{index+1}. #{song.artist.name} - #{song.name} - #{song.genre.name}"
    end
  end
  
  def list_artists
    artists = Artist.all.sort {|a, b| a.name <=> b.name}
    artists.each_with_index do |artist, index|
      puts "#{index+1}. #{artist.name}"
    end
  end
  
  def list_genres
    genres = Genre.all.sort {|a, b| a.name <=> b.name}
    genres.each_with_index do |genre, index|
      puts "#{index+1}. #{genre.name}"
    end
  end
  
  def list_songs_by_artist
    puts "Please enter the name of an artist:"
    input = gets.strip
    if artist = Artist.find_by_name(input)
      songs = artist.songs.sort {|a, b| a.name <=> b.name}
      songs.each_with_index do |song, index|
        puts "#{index+1}. #{song.name} - #{song.genre.name}"
      end
    end
  end
  
  def list_songs_by_genre
    puts "Please enter the name of a genre:"
    input = gets.strip
    if genre = Genre.find_by_name(input)
      songs = genre.songs.sort {|a, b| a.name <=> b.name}
      songs.each_with_index do |song, index|
        puts "#{index+1}. #{song.artist.name} - #{song.name}"
      end
    end
  end

  def play_song
    puts "Which song number would you like to play?"
    input = gets.strip.to_i
    songs = Song.all.uniq.sort {|a, b| a.name <=> b.name}
    if input >= 1 && input <= songs.count && songs[input-1]
      puts "Playing #{songs[input-1].name} by #{songs[input-1].artist.name}"
    end
  end

  describe "'list songs'" do
    it "triggers #list_songs" do
      allow(music_library_controller).to receive(:gets).and_return("list songs", "exit")

      expect(music_library_controller).to receive(:list_songs)

      capture_puts { music_library_controller.call }
    end
  end

  describe "'list artists'" do
    it "triggers #list_artists" do
      allow(music_library_controller).to receive(:gets).and_return("list artists", "exit")

      expect(music_library_controller).to receive(:list_artists)

      capture_puts { music_library_controller.call }
    end
  end

  describe "'list genres'" do
    it "triggers #list_genres" do
      allow(music_library_controller).to receive(:gets).and_return("list genres", "exit")

      expect(music_library_controller).to receive(:list_genres)

      capture_puts { music_library_controller.call }
    end
  end

  describe "'list artist'" do
    it "triggers #list_songs_by_artist" do
      allow(music_library_controller).to receive(:gets).and_return("list artist", "exit")

      expect(music_library_controller).to receive(:list_songs_by_artist)

      capture_puts { music_library_controller.call }
    end
  end

  describe "'list genre'" do
    it "triggers #list_songs_by_genre" do
      allow(music_library_controller).to receive(:gets).and_return("list genre", "exit")

      expect(music_library_controller).to receive(:list_songs_by_genre)

      capture_puts { music_library_controller.call }
    end
  end

  describe "'play song'" do
    it "triggers #play_song" do
      allow(music_library_controller).to receive(:gets).and_return("play song", "2", "exit")

      expect(music_library_controller).to receive(:play_song)

      capture_puts { music_library_controller.call }
    end
  end

end