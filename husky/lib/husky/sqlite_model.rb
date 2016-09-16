require "sqlite3"
require "husky/util"

DB = SQLite3::Database.new "test.db"

module Husky
  module Model
    class SQLite
      def self.table
        Husky.to_underscore(name)
      end

      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info(table) do |row|
          @schema[row["name"]] = row["type"]
        end

        @schema
      end

      def self.to_sql(val)
        case val
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL"
        end
      end

      def self.create(values)
        values.delete('id')
        keys = schema.keys - ['id']
        vals = keys.map do |key|
          values[key] ? to_sql(values[key]) : "null"
        end

        DB.execute <<-SQL
        INSERT INTO #{table} (#{keys.join(',')}) VALUES
        (#{vals.join(',')});
        SQL

        data = Hash[keys.zip vals]
        sql = "SELECT last_insert_rowid();"
        data["id"] = DB.execute(sql)[0][0]
        self.new data
      end

      def self.count
        sql = <<-SQL
        SELECT COUNT(*) FROM #{table};
        SQL

        DB.execute(sql)[0][0]
      end

      def initialize(data = nil)
        @hash = data
      end

      def self.find(id)
        sql = <<-SQL
        SELECT #{schema.keys.join(',')} FROM #{table} WHERE id = #{id};
        SQL

        row = DB.execute(sql)
        data = Hash(schema.keys.zip(row[0]))
        self.new data
      end

      def self.all
        sql = <<-SQL
        SELECT #{schema.keys.join(',')} FROM #{table};
        SQL

        results = DB.execute(sql)
        results.map do |row|
          data = Hash[schema.keys.zip(row)]
          self.new data
        end
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end
    end
  end
end
