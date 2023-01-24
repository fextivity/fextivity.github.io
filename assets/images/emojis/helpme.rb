require 'gemoji'

emoji = Emoji.create("icant") do |char|
  char.image_filename = "icant.webp"
end