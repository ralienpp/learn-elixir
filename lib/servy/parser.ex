defmodule Servy.Parser do

	# alias Servy.Conv, as: Conv
	# same as above, but more concise
	alias Servy.Conv

	def parse(request) do
	    [method, url, _version] =
	    	request
	    	|> String.split("\n")
	    	|> List.first
	    	|> String.split(" ")

	    # We treat this as a struct, not as a regular map,
	    # note that we don't provide values for all elements,
	    # because they're already defined in the struct itself.
	    %Conv{method: method, path: url}
	end
end