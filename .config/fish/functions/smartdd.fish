function smartdd --argument source dest
    # 1. Input Validation
    if test -z "$source"; or test -z "$dest"
        echo "Usage: smartdd <input_file_or_dev_zero> <destination_device>"
        return 1
    end

    if not test -e "$dest"
        echo "Error: Destination $dest does not exist."
        return 1
    end

    # 2. Variable Setup
    set bs_size "4M" # Optimal speed for most modern drives
    set count_bytes 0
    set mode ""

    # 3. Determine Mode & Calculate Size
    if test "$source" = "/dev/zero"
        # MODE: Zero Wipe
        # We need the size of the DESTINATION drive to know when to stop.
        set mode "WIPE"
        
        # Try lsblk first (Linux standard)
        if type -q lsblk
             set count_bytes (lsblk -b -n -o SIZE $dest | head -n 1)
        else
            # Fallback for Git Bash / MSYS (Parsing /proc/partitions)
            # Finds the block count and multiplies by 1024 to get bytes
            set blocks (cat /proc/partitions | grep (basename $dest)\$ | awk '{print $3}')
            if test -n "$blocks"
                set count_bytes (math "$blocks * 1024")
            end
        end
    else
        # MODE: Flash Image
        # We need the size of the INPUT file.
        set mode "FLASH"
        
        if not test -e "$source"
            echo "Error: Source file $source not found."
            return 1
        end
        
        # Get file size (stat -c %s is standard Linux; stat -f %z is BSD/Mac)
        if type -q stat
            # Check if we are on Linux/GitBash or Mac
            if stat --version > /dev/null 2>&1
                set count_bytes (stat -c %s "$source") # GNU/Linux
            else
                set count_bytes (stat -f %z "$source") # BSD/Mac
            end
        else
            echo "Error: 'stat' command missing. Cannot calculate file size."
            return 1
        end
    end

    # 4. Safety Check & Confirmation
    if test "$count_bytes" -eq 0
        echo "Error: Could not determine size. Aborting."
        return 1
    end
    
    set size_human (math -s0 "$count_bytes / 1024 / 1024")
    echo "---------------------------------------------------"
    echo "Mode:      $mode"
    echo "Source:    $source"
    echo "Target:    $dest"
    echo "Data Size: $count_bytes bytes (~$size_human MB)"
    echo "---------------------------------------------------"
    read -P "Press [Enter] to start or [Ctrl+C] to cancel..." confirm

    # 5. Execution
    # iflag=count_bytes: The secret sauce. Allows 'count' to be precise bytes 
    # while keeping 'bs' large for speed.
    dd if="$source" of="$dest" bs=$bs_size count=$count_bytes iflag=count_bytes status=progress
    
    # 6. Final Sync
    echo "Syncing cache..."
    sync
    echo "Done."
end
