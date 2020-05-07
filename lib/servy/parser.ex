defmodule Servy.Parser do

	# alias Servy.Conv, as: Conv
	# same as above, but more concise
	alias Servy.Conv

	def parse(request) do
		[header, raw_params] = String.split(request, "\n\n")

		[request_line | _headers] = String.split(header, "\n")

	    [method, url, _version] = String.split(request_line, " ")
	    	# header
	    	# |> String.split("\n")
	    	# |> List.first
	    	# |> String.split(" ")

	    params = parse_params(raw_params)

	    # We treat this as a struct, not as a regular map,
	    # note that we don't provide values for all elements,
	    # because they're already defined in the struct itself.
	    %Conv{method: method, path: url,
	          params: params
	}
	end

	def parse_params(params) do
		params |> String.trim |> URI.decode_query
	end
end