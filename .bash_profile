# With thanks to Todd Werth
# http://blog.infinitered.com/entries/show/4
# and
# https://github.com/twerth/dotfiles
#
# When you start an interactive shell (log in, open terminal or iTerm
# in OS X, or create a new tab in iTerm) the following files are read and
# run, in this order:
#     /etc/profile
#     /etc/bashrc
#     ~/.bash_profile
#     ~/.bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started
# (when you run "bash" from inside a shell, or when you start a shell in
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and
# executed, in this order:
#     /etc/bashrc
#     ~/.bashrc
#

# Include .bashrc.
. ~/.bashrc
