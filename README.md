tv-show-finder
==============

find tv show from your download and make it accessible from a xbmc installation.

Since XBMC scraper need to have a very strict filetree to recognize tv shows, this script make a filetree, with symlink to not occupy tons of Gb of disk, that works better with xbmc and symlink to your tv shows.

This script run in daemon mode, trigging inotify events, and is based on ruby regexp to recognize tv show. Feel free to ameliorate it.

## How to install it ?

This script runs with ruby > 1.9.1. It also need mkmf tool that comes with ruby, please see your distro. In ubuntu, it comes with ruby1.9.1-dev.

In ubuntu: install ruby1.9.1 and ruby1.9.1-dev packages. Remove ruby1.8, it is obsolete.

Then, for all distros, as root: gem install micro-optparse rb-inotify

## How to use it ?

This script runs in daemon mode, triggering for a new download to be symlinked. To launch it, run this:
./tv-show-finder.rb -s my_torrent_download_directory -o empty_directory_i_will_provide_to_xbmc

To start it at your computer boot: 
crontab -e

use nano

add this line:
@reboot cd path_to_where_i_install_tv_show_finder && /tv-show-finder.rb -s my_torrent_download_directory -o empty_directory_i_will_provide_to_xbmc
 
That's All, Enjoy !
