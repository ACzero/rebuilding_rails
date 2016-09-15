require 'husky'

$LOAD_PATH << File.join(File.dirname(__FILE__),
                        "..", "app",
                       "controllers")

module BestQuotes
  class Application < Husky::Application
  end
end
