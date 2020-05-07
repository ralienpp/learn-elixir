defmodule Servy.Plugins do

	alias Servy.Conv

	@doc "Logs 404 requests, indicating their path"
	def track(%Conv{status: 404, path: path} = conv) do
		IO.puts "Warning, no such path `#{path}`"
		# make sure you return the conv here, so the
		# pipeline keeps flowing
		conv
	end

	# default handler for all other cases of `track`
	def track(%Conv{} = conv), do: conv


	# this will only change the paths that begin with
	# "/wildlife"
	def rewrite_path(%Conv{path: "/wildlife"} = conv) do
		%{conv|path: "/wildthings"}
	end

	# default handler for the above, all the other paths
	# will fall to this handler and leave things unchanged
	def rewrite_path(%Conv{} = conv), do: conv

	def log(%Conv{} = conv), do: IO.inspect conv
end
