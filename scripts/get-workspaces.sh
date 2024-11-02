# Check if Hyprland is running and get the correct socket path
get_socket_path() {
    SOCKET_PATH="/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
    if [ ! -e "$SOCKET_PATH" ]; then
        # Fallback: try to find the socket directly
        SOCKET_PATH=$(find /tmp/hypr -name ".socket2.sock" 2>/dev/null | head -n 1)
    fi
    echo "$SOCKET_PATH"
}

# Function to get all workspace information
get_workspaces() {
    # Get active workspace ID
    active_workspace=$(hyprctl activeworkspace -j | jq '.id')
    
    # Get all workspace data
    workspace_windows=$(hyprctl workspaces -j | jq --argjson active "$active_workspace" '
        [range(1; 6)] |
        map(. as $wsnum |
            (
                ($wsnum |
                tostring) as $ws_str |
                {
                    id: $wsnum,
                    windows: (
                        .. | 
                        objects | 
                        select(.id == $wsnum) | 
                        .windows // 0
                    ),
                    active: ($wsnum == $active),
                    monitor: (
                        .. |
                        objects |
                        select(.id == $wsnum) |
                        .monitor // ""
                    )
                }
            )
        )
    ')

    # Output the workspace data
    echo "$workspace_windows"
}

# Initial state
get_workspaces

# Get the socket path
SOCKET_PATH=$(get_socket_path)

if [ -z "$SOCKET_PATH" ]; then
    echo "Error: Could not find Hyprland socket" >&2
    exit 1
fi

# Monitor for workspace events
socat -u UNIX-CONNECT:"$SOCKET_PATH" - | while read -r line; do
    case "${line%>>*}" in
        "workspace"|"createworkspace"|"destroyworkspace"|"focusedmon"|"moveworkspace"|"windowclose"|"windowopen")
            get_workspaces
            ;;
    esac
done
