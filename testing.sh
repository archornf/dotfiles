
#!/bin/bash
        if dpkg -l | grep -qw "neovim"; then
            echo "EXISTS"
        else
            echo "NO"
        fi
