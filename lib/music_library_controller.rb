class MusicLibraryController
  describe "MusicLibraryController" do
    
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

  describe "#call" do

    it "asks the user for input" do
      allow(music_library_controller).to receive(:gets).and_return("exit")

      expect(music_library_controller).to receive(:gets)

      capture_puts { music_library_controller.call }
    end

    it "loops and asks for user input until they type in exit" do
      allow(music_library_controller).to receive(:gets).and_return("a", "b", "c", "exit")

      expect(music_library_controller).to receive(:gets).exactly(4).times

      capture_puts { music_library_controller.call }
    end
  end
end
end