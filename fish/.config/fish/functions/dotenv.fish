function dotenv -a file
	while read -l line
		eval "export $line"
	end <$file >/dev/null
end
