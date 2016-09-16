class QuotesController < Husky::Controller
  def a_quote
    env_strs = env.map { |k,v| %Q{ <pre>"#{k}" => "#{v}"</pre> } }
    "test rerun " +
      "but thinking makes it so." +
      %Q[\n#{env_strs.join("\n")}\n]

    @test = "instance_variables"
    render :a_quote
  end

  def index
    @quotes = FileModel.all
    render :index
  end

  def quote_1
    @quote = FileModel.find(1)
    render :quote
  end

  def new_quote
    attrs = {
      "submitter" => "new user",
      "quote" => "A picture is worth a thousand pixels",
      "attribution" => "Me"
    }

    @quote = FileModel.create(attrs)
    render :quote
  end

  def exception
    raise "It's a bad one!"
  end
end
