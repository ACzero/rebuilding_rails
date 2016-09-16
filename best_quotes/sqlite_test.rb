require "sqlite3"
require "husky/sqlite_model"

class MyTable < Husky::Model::SQLite; end
STDERR.puts MyTable.schema.inspect
