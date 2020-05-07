defmodule Servy.Handler do
	def handle(request) do
		#conv = parse(request)
		#conv = route(conv)
		#format_response(conv)

		request
		|> parse
		|> log
		|> route
		|> format_response
	end

	# def log(conv) do
	#	IO.inspect conv
	# end

	# same as above
	def log(conv), do: IO.inspect conv

	def parse_sosolala(request) do
	    first_line = request |> String.split("\n") |> List.first

	    # parts = String.split(first_line, " ")
	    # method = Enum.at(parts, 0)
	    # url = Enum.at(parts, 1)

	    [method, url, _version] = String.split(first_line, " ")

		# conv = %{method: method, path: url, resp_body: ""}
		# The last expression is returned by default, so we can
		# just get rid of it
		%{method: method, path: url, resp_body: ""}
	end

	# this one is idiomatic Elixir
	def parse(request) do
	    [method, url, _version] =
	    	request
	    	|> String.split("\n")
	    	|> List.first
	    	|> String.split(" ")
		%{method: method, path: url, resp_body: "", status: nil}
	end

	def route_old(conv) do
		# %{ conv | resp_body: "vvvvvvvery new response"}
		if conv.path == "/url" do
			%{conv| resp_body: "generic url"}
		else
			%{conv| resp_body: "specific url for bears"}
		end
	end

	def route(conv) do
		route(conv, conv.method, conv.path)
	end

	def route(conv, "GET","/url") do
		%{conv| status: 200, resp_body: "generic url"}
	end

	def route(conv, "GET", "/bears") do
		%{conv| status: 200, resp_body: "specific url for bears"}
	end

	# this is a default handler which is invoked when
	# none of the above `route` functions is matched
	# NOTE that it must be physically the last entry,
	#      otherwise it will eagerly match anything
	#      and the other handlers won't be invoked.
	def route(conv, _method, _path) do
		%{conv| status: 404, resp_body: "No such path on the server"}
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

request_bigf = """
GET /bigfoot HTTP/1.1
Host: example.com
Accept: */*
User-Agent: murzik/1.0

"""


response = Servy.Handler.handle(request)
IO.puts response


IO.puts Servy.Handler.handle(request_bears)

IO.puts Servy.Handler.handle(request_bigf)