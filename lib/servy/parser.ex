defmodule Servy.Parser do
	def parse(request) do
	    [method, url, _version] =
	    	request
	    	|> String.split("\n")
	    	|> List.first
	    	|> String.split(" ")

	    # We treat this as a struct, not as a regular map,
	    # note that we don't provide values for all elements,
	    # because they're already defined in the struct itself.
	    %Servy.Conv{method: method, path: url}
	end
end