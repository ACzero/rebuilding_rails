require "sqlite3"
require "husky/sqlite_model"

class MyTable < Husky::Model::SQLite; end
STDERR.puts MyTable.schema.inspect

# MyTable.create "title" => "It happened!",
#   "posted" => 1, "body" => "It did!"
# MyTable.create "title" => "I saw it!"

puts "Count : #{MyTable.count}"

MyTable.all.each do |i|
  puts "Found title #{i["title"]}"
end
