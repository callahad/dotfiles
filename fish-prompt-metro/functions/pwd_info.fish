function pwd_info -a separator -d "Print easy-to-parse information the current working directory"
    set -l home ~
    set -l git_root (command git rev-parse --show-toplevel 2> /dev/null)

    command pwd -L | awk -v home="$home" -v git_root="$git_root" -v separator="$separator" '
        function base(string) {
            sub(/^\/?.*\//, "", string)
            return string
        }
        function dirs(string, printLastName,   prefix, path) {
            len = split(string, parts, "/")
            for (i = 1; i < len; i++) {
                if (parts[i] == "") {
                    continue
                }
                name = substr(parts[i], 1, parts[i] ~ /^\./ ? 2 : 1)
                path = path prefix name
                prefix = separator
            }
            return (printLastName == 1) ? path prefix parts[len] : path
        }
        function remove(thisString, fromString) {
            sub(thisString, "", fromString)
            return fromString
        }
        {
            if (git_root == home) {
                git_root = ""
            }
            if (git_root == "") {
                printf("%s\n%s\n%s\n",
                    $0 == home || $0 == "/" ? "" : base($0),
                    dirs(remove(home, $0)),
                    "")
            } else {
                printf("%s\n%s\n%s\n",
                    base(git_root),
                    dirs(remove(home, git_root)),
                    $0 == git_root ? "" : dirs(remove(home, remove(git_root, $0)), 1))
            }
        }
    '
end
