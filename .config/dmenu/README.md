# Modified version of Luke's dmenu

Besides the features below, I have also added:
https://tools.suckless.org/dmenu/patches/center/
https://tools.suckless.org/dmenu/patches/border/
And also a max width in the code, as well as some changes to the coloring.

Extra stuff added to vanilla dmenu:

- reads Xresources (ergo pywal compatible)
- alpha patch, which importantly allows this build to be embedded in transparent st
- can view color characters like emoji
- `-P` for password mode: hide user input
- `-r` to reject non-matching input
- dmenu options are mouse clickable

## Installation

After making any config changes that you want, but `make`, `sudo make install` it.
