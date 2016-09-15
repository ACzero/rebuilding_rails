$LOAD_PATH << File.join(File.dirname(__FILE__),
                        "..", "app",
                       "controllers")

require 'husky'
require 'quotes_controller'

module BestQuotes
  class Application < Husky::Application
  end
end
