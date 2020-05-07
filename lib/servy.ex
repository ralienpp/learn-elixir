defmodule Servy do
  def hello(name) do
    "Hello, #{name}!"
    #:world
  end
end


IO.puts Servy.hello("Medwed")
