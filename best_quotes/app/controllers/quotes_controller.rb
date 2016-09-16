class QuotesController < Husky::Controller
  def a_quote
    env_strs = env.map { |k,v| %Q{ <pre>"#{k}" => "#{v}"</pre> } }
    "test rerun " +
      "but thinking makes it so." +
      %Q[\n#{env_strs.join("\n")}\n]

    render :a_quote, "@test" => :abc
  end

  def exception
    raise "It's a bad one!"
  end
end
