class QuotesController < Husky::Controller
  def a_quote
    env_strs = env.map { |k,v| %Q{ <pre>"#{k}" => "#{v}"</pre> } }
    "There is nothing either good or bad " +
      "but thinking makes it so." +
      %Q[\n#{env_strs.join("\n")}\n]
  end
end
