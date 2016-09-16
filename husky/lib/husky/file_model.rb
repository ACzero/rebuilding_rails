require "multi_json"

module Husky
  module Model
    class FileModel
      attr_accessor :filename

      def initialize(filename)
        self.filename = filename

        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue
          return nil
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new(f) }
      end

      def self.create(attrs)
        hash = {}
        %w(submitter quote attribution).each do |attr|
          hash[attr] = attrs[attr] || ""
        end

        files = Dir["db/quotes/*.json"]
        names = files.map { |f| f.split("/")[-1] }
        highest = names.map { |b| b[0..-5].to_i }.max
        id = highest + 1

        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write <<-TEMPLATE
          {
            "submitter": "#{hash["submitter"]}",
            "quote": "#{hash["quote"]}",
            "attribution": "#{hash["attribution"]}"
          }
          TEMPLATE
        end

        FileModel.new("db/quotes/#{id}.json")
      end
    end
  end
end
