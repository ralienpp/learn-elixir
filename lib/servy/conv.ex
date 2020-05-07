defmodule Servy.Conv do
	defstruct method: "", path: "", resp_body: "", status: nil

	def full_status(conv) do
		"#{conv.status} #{status_reason(conv.status)}"
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