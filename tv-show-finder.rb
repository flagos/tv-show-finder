#!/usr/bin/env ruby

require 'micro-optparse'
require 'rb-inotify'

options = Parser.new do |p|
  p.banner = "TV show finder will recognize what folder is a TV show. This script is essentially made to make xbmc happy with tv show"
  p.option :scan_dir, "directory to scan", :default => ""
  p.option :output_dir, "directory where symlinks to tv show will be done", :default => ""
end.process!


# clean pathes
options[:scan_dir]  = File.absolute_path(options[:scan_dir])
options[:output]    = File.absolute_path(options[:output_dir])

# Symlink in output dir the torrent we want to add in tv show dir
def push_to_output(path, tv_show_name, season, output)
  puts path
  dir = "#{output}/#{tv_show_name}/"
  symlink = "#{output}/#{tv_show_name}/season_#{season}"
  if (!File.exists?(dir))
    Dir.mkdir ( dir)
  end
  if (!File.exists?(symlink))
    File.symlink(path,symlink)
  end
end

def scan(options)
  input = Dir.new(options[:scan_dir])

  input.each{|dir|
    if (!(dir == '.' || dir == '..'))
      full_path = File.absolute_path(options[:scan_dir] + '/' + dir)
      if (File.directory?(full_path))
        if (/(.*)S(aison|eason)?\s*(\d)+.*/.match(dir))
          puts dir
          push_to_output(full_path, $1, $3, options[:output_dir])
        end
      end
    end
  }
end

notifier = INotify::Notifier.new
notifier.watch(options[:scan_dir], :moved_to, :create){scan(options)}

notifier.run
