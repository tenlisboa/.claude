cl() {
    # Check if Claude Code is installed
    if ! command -v claude &> /dev/null; then
        echo "Error: Claude Code is not installed. Please install it first."
        echo "Visit: https://docs.claude.com/en/docs/claude-code"
        return 1
    fi
    
    # Check if query is provided
    if [ $# -eq 0 ]; then
        echo "Usage: cl \"your question or command\""
        echo "Example: cl \"How to disconnect from openvpn3 network\""
        return 1
    fi
    
    # Define strategic directories to include (customize these)
    local strategic_dirs=(
        "$HOME/.config"           # Configuration files
        "/etc"                    # System configuration
        "/usr/local/bin"          # Custom scripts/binaries
    )
    
    # Build the --add-dir flags for existing directories
    local add_dir_flags=""
    for dir in "${strategic_dirs[@]}"; do
        if [ -d "$dir" ]; then
            add_dir_flags="$add_dir_flags --add-dir $dir"
        fi
    done
    
    # Always add current directory
    add_dir_flags="$add_dir_flags --add-dir $PWD"

    local info=$(lsb_release -a 2>/dev/null)
    
    # Add system context to the query
    local enhanced_query="You are my terminal command line helper.
    My operational system is:
     $info
     
    I will ask you something about my operational system or anything about the directory that I am using currently.
    You are running in my terminal so, think on this perspective
    
    Get the query that I sent, think about what I mean, and provide an answer.
    "
    
    # Execute Claude Code with the flags
    # Using default permission mode (prompts for edits/dangerous commands)
    claude $2 $1 \
        $add_dir_flags \
        --allowedTools "Bash,Read,WebSearch" \
        --append-system-prompt "$enhanced_query" \
}
