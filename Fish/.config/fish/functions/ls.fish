function ls --description 'List contents of directory'

	if type -q eza
		command eza --all --classify --group --sort=Name $argv
	else
		set -l param

		if test (uname -s) = 'Darwin' # macOS
			set param -A -G
			if isatty 1
				set param $param -F
			end
		else # Linux
			set param --almost-all --color=auto
			if isatty 1
				set param $param --indicator-style=classify
			end
		end

		command ls $param $argv
	end
end
