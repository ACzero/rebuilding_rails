class QuotesController < Husky::Controller
  def a_quote
    env_strs = env.map { |k,v| %Q{ <pre>"#{k}" => "#{v}"</pre> } }
    "test rerun " +
      "but thinking makes it so." +
      %Q[\n#{env_strs.join("\n")}\n]

    @test = "instance_variables"
  end

  def index
    @quotes = FileModel.all
  end

  def show
    @quote = FileModel.find(params["id"])
    @ua = request.user_agent
  end

  def new_quote
    attrs = {
      "submitter" => "new user",
      "quote" => "A picture is worth a thousand pixels",
      "attribution" => "Me"
    }

    @quote = FileModel.create(attrs)
  end

  def update
    if self.env["REQUEST_METHOD"] == "POST"
      quote = FileModel.find(params["id"])
      return 'not found' unless quote

      quote.submitter = "update submitter"
      quote.save

      'success'
    else
      'post only'
    end
  end

  def exception
    raise "It's a bad one!"
  end
end
