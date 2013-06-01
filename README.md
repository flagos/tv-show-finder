tv-show-finder
==============

find tv show from your download and make it accessible from a xbmc installation.

Since XBMC scraper need to have a very strict filetree to recognize tv shows, this script make a filetree, with symlink to not occupy Gb of disk, that works better with xbmc.

This script run in daemon mode, trigging inotify events, and is based on ruby regexp to recognize tv show. Feel free to ameliorate it.
