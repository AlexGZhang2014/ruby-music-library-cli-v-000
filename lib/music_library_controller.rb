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
    
    call unless input == "exit"
  end
  
  def list_songs
    songs = Song.all.sort {|a, b| a.name <=> b.name}
    songs.each_with_index do |song, index|
      puts "#{index+1}. #{song.artist.name} - #{song.name} = #{song.genre.name}"
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
    songs = Artist.songs.sort {|a, b| a.name <=> b.name}
    songs.each_with_index do |song, index|
      puts "#{index+1}. #{song.name} - #{song.genre.name}"
    end
    
  end

  describe "#list_songs_by_artist" do

    it "prints all songs by a particular artist in a numbered list (alphabetized by song name)" do
      Song.create_from_filename("Real Estate - Wonder Years - dream pop.mp3")

      allow(music_library_controller).to receive(:gets).and_return("Real Estate")

      expect($stdout).to receive(:puts).with("Please enter the name of an artist:")
      expect($stdout).to receive(:puts).with("1. Green Aisles - country")
      expect($stdout).to receive(:puts).with("2. It's Real - hip-hop")
      expect($stdout).to receive(:puts).with("3. Wonder Years - dream pop")

      music_library_controller.list_songs_by_artist
    end

    it "does nothing if no matching artist is found" do
      allow(music_library_controller).to receive(:gets).and_return("Eel Restate")

      expect($stdout).to receive(:puts).with("Please enter the name of an artist:")
      expect($stdout).to_not receive(:puts)

      music_library_controller.list_songs_by_artist
    end
  end

  describe "#list_songs_by_genre" do
    it "prompts the user to enter a genre" do
      allow(music_library_controller).to receive(:gets).and_return("Testing for #puts")

      expect($stdout).to receive(:puts).with("Please enter the name of a genre:")

      music_library_controller.list_songs_by_genre
    end

    it "accepts user input" do
      allow(music_library_controller).to receive(:gets).and_return("Testing for #gets")

      expect(music_library_controller).to receive(:gets)

      music_library_controller.list_songs_by_genre
    end

    it "prints all songs by a particular genre in a numbered list (alphabetized by song name)" do
      allow(music_library_controller).to receive(:gets).and_return("hip-hop")

      expect($stdout).to receive(:puts).with("Please enter the name of a genre:")
      expect($stdout).to receive(:puts).with("1. Real Estate - It's Real")
      expect($stdout).to receive(:puts).with("2. Jurassic 5 - What's Golden")

      music_library_controller.list_songs_by_genre
    end

    it "does nothing if no matching genre is found" do
      allow(music_library_controller).to receive(:gets).and_return("post-jazz")

      expect($stdout).to receive(:puts).with("Please enter the name of a genre:")
      expect($stdout).to_not receive(:puts)

      music_library_controller.list_songs_by_genre
    end
  end

  describe "#play_song" do
    it "prompts the user to choose a song from the alphabetized list output by #list_songs" do
      allow(music_library_controller).to receive(:gets).and_return("Testing for #puts")

      expect($stdout).to receive(:puts).with("Which song number would you like to play?")

      allow($stdout).to receive(:puts)

      music_library_controller.play_song
    end

    it "accepts user input" do
      allow(music_library_controller).to receive(:gets).and_return("Testing for #gets")

      expect(music_library_controller).to receive(:gets)

      music_library_controller.play_song
    end

    it "upon receiving valid input 'plays' the matching song from the alphabetized list output by #list_songs" do
      allow(music_library_controller).to receive(:gets).and_return("4")

      expect($stdout).to receive(:puts).with("Which song number would you like to play?")
      expect($stdout).to receive(:puts).with("Playing Larry Csonka by Action Bronson")

      music_library_controller.play_song
    end

    it "does not 'puts' anything out if a matching song is not found" do
      allow(music_library_controller).to receive(:gets).and_return("6")

      expect($stdout).to receive(:puts).with("Which song number would you like to play?")
      expect($stdout).to_not receive(:puts)

      music_library_controller.play_song
    end

    it "checks that the user entered a number between 1 and the total number of songs in the library" do
      allow(music_library_controller).to receive(:gets).and_return("0")

      expect($stdout).to receive(:puts).with("Which song number would you like to play?")
      expect($stdout).to_not receive(:puts)

      music_library_controller.play_song
    end
  end

end