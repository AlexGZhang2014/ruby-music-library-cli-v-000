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
    if artist = Artist.
      songs = input.songs.sort {|a, b| a.name <=> b.name}
      songs.each_with_index do |song, index|
        puts "#{index+1}. #{song.name} - #{song.genre.name}"
      end
    end
  end
  
  def list_songs_by_genre
    puts "Please enter the name of a genre:"
    input = gets.strip
    if Genre.all.include?(input)
      songs = input.songs.sort {|a, b| a.name <=> b.name}
      songs.each_with_index do |song, index|
        puts "#{index+1}. #{song.artist.name} - #{song.name}"
      end
    end
  end

  def play_song
    puts "Which song number would you like to play?"
    input = gets.strip
    songs = Song.all.sort {|a, b| a.name <=> b.name}
    if input >= 1 && input <= songs.count && songs[input-1]
      puts "Playing #{songs[input-1]} by #{songs[input-1].artist}"
    end
  end

end