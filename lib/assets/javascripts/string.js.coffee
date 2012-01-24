String.prototype.repeat = (num) ->
  buf = ""
  buf += this for i in [0..num-1]
  return buf

String.prototype.rjust = (width, padding) ->
	padding = padding || " "
	padding = padding.substr(0, 1)
	return if this.length < width then (padding.repeat(width - this.length) + this) else this
