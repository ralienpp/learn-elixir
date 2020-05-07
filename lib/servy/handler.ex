defmodule Servy.Handler do

	@moduledoc "Basic handler of HTTP requests."

	@version "0.0.4"

	def initialize do
		IO.puts "Starting server v.#{@version}"
	end

	@doc "Transforms a request into a response"
	def handle(request) do
		request
		|> parse
		|> rewrite_path
		|> log
		|> route
		|> track
		|> format_response
	end

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

	# this one is idiomatic Elixir
	def parse(request) do
	    [method, url, _version] =
	    	request
	    	|> String.split("\n")
	    	|> List.first
	    	|> String.split(" ")
		%{method: method, path: url, resp_body: "", status: nil}
	end


	def route(%{method: "GET", path: "/url"} = conv) do
		%{conv| status: 200, resp_body: "generic url"}
	end

	def route(%{method: "GET", path: "/bears"} = conv) do
		%{conv| status: 200, resp_body: "specific url for bears"}
	end

	def route(%{method: "GET", path: "/bears/" <> id} = conv) do
		%{conv| status: 200, resp_body: "Bear ID=#{id}"}
	end

	def route(%{method: "GET", path: "/about"} = conv) do
		File.read("pages/about.html")
		# NOTE: the tuple returned by File.read is implicitly
		#		the first argument passed to the next function
		#		in the pipeline; this is now shown, to have a
		#		laconic representation
		|> handle_file(conv)
	end

	# this is a default handler which is invoked when
	# none of the above `route` functions is matched
	# NOTE that it must be physically the last entry,
	#      otherwise it will eagerly match anything
	#      and the other handlers won't be invoked.
	def route(%{path: path} = conv) do
		%{conv| status: 404, resp_body: "No such path on the server #{path}"}
	end

	def handle_file({:ok, content}, conv) do
		%{conv| status: 200, resp_body: "#{content}"}
	end

	def handle_file({:error, :enoent}, conv) do
		%{conv| status: 404, resp_body: "File not found, schade!"}
	end

	def handle_file({:error, reason}, conv) do
		%{conv| status: 500, resp_body: "File error: #{reason}"}
	end

	def format_response(conv) do
		"""
		HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
		Content-Type: text/plain
		Content-Length: #{String.length(conv.resp_body)}

		#{conv.resp_body}
		"""
	end

	defp status_reason(code) do
		# defp makes it a "private" function that only
		# works inside this module
		%{
			200 => "OK",
			404 => "Not found",
			500 => "Internal server error"
		}[code]
	end
end

request = """
GET /url HTTP/1.1
Host: example.com
Accept: */*
User-Agent: murzik/1.0

"""

request_bears = """
GET /bears HTTP/1.1
Host: example.com
Accept: */*
User-Agent: murzik/1.0

"""

request_bears_specific = """
GET /bears/45 HTTP/1.1
Host: example.com
Accept: */*
User-Agent: murzik/1.0

"""

request_bigf = """
GET /bigfoot HTTP/1.1
Host: example.com
Accept: */*
User-Agent: murzik/1.0

"""

request_wildlife = """
GET /wildlife HTTP/1.1
Host: example.com
Accept: */*
User-Agent: murzik/1.0

"""

request_about = """
GET /about HTTP/1.1
Host: example.com
Accept: */*
User-Agent: murzik/1.0

"""


Servy.Handler.initialize
response = Servy.Handler.handle(request)
IO.puts response


IO.puts Servy.Handler.handle(request_bears)

IO.puts Servy.Handler.handle(request_bears_specific)

# note how this one will be rewritten as /wildthings
IO.puts Servy.Handler.handle(request_wildlife)

IO.puts Servy.Handler.handle(request_bigf)
IO.puts Servy.Handler.handle(request_about)