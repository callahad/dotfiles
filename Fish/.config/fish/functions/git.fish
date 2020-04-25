function git --wraps hub --description 'Alias for hub, which wraps git to provide extra functionality with GitHub.'
    if type -q hub
        hub $argv
    else
        command git $argv
    end
end
