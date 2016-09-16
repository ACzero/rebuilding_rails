require "multi_json"

module Husky
  module Model
    class FileModel
      attr_accessor :filename

      def self.all_attrs
        %w(submitter quote attribution)
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
        self.all_attrs.each do |attr|
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

      def []=(attr, value)
        @hash[attr.to_s] = value
      end

      def save
        File.open(self.filename, "w+") do |f|
          f.write MultiJson.dump(@hash)
        end
      end

      def method_missing(method, *args)
        attrs = FileModel.all_attrs.dup
        writers = attrs.map { |attr| "#{attr}=" }
        if attrs.include?(method.to_s)
          @hash[method.to_s]
        elsif writers.include?(method.to_s)
          @hash[method.to_s.gsub(/=/, "")] = args.first
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        readers = FileModel.all_attrs
        writers = readers.map { |attr| "#{attr}=" }

        readers.include?(method.to_s) || writers.include?(method.to_s) || super
      end
    end
  end
end
