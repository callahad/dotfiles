function cat
    if type -q bat
        bat --style=plain $argv
    else
        command cat $argv
    end
end
