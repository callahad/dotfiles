function tree --description 'Visualize contents of directories in a tree'
	if type -q eza
		command eza --tree --all --classify --group --sort=Name $argv
	else if type -q tree
		command tree -aFC --noreport $argv
	else
		echo "tree: command not found" > /dev/stderr
		return 127
	end
end
