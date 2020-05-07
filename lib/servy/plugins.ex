defmodule Servy.Plugins do
	@doc "Logs 404 requests, indicating their path"
	def track(%{status: 404, path: path} = conv) do
		IO.puts "Warning, no such path `#{path}`"
		# make sure you return the conv here, so the
		# pipeline keeps flowing
		conv
	end

	# default handler for all other cases of `track`
	def track(conv), do: conv


	# this will only change the paths that begin with
	# "/wildlife"
	def rewrite_path(%{path: "/wildlife"} = conv) do
		%{conv|path: "/wildthings"}
	end

	# default handler for the above, all the other paths
	# will fall to this handler and leave things unchanged
	def rewrite_path(conv), do: conv

	def log(conv), do: IO.inspect conv
end
