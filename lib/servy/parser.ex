defmodule Servy.Parser do
	def parse(request) do
	    [method, url, _version] =
	    	request
	    	|> String.split("\n")
	    	|> List.first
	    	|> String.split(" ")
		%{method: method, path: url, resp_body: "", status: nil}
	end
end