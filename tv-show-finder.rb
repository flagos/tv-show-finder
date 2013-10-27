#!/usr/bin/env ruby


# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE"
# flagospub@gmail.com wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return 
# ----------------------------------------------------------------------------


require 'micro-optparse'
require 'rb-inotify'
require 'fileutils'

options = Parser.new do |p|
  p.banner = "TV show finder will recognize what folder is a TV show. This script is essentially made to make xbmc happy with tv show"
  p.option :scan_dir, "directory to scan", :default => ""
  p.option :output_dir, "directory where symlinks to tv show will be done", :default => ""
end.process!


# clean pathes
options[:scan_dir]  = File.absolute_path(options[:scan_dir])
options[:output]    = File.absolute_path(options[:output_dir])

# Symlink in output dir the torrent we want to add in tv show dir
def push_to_output(path, tv_show_name, season, output, episod="")
  puts path
  dir = "#{output}/#{tv_show_name}/"
  symlink = "#{output}/#{tv_show_name}/season_#{season}"
  if (episod!="")
    dir = "#{output}/#{tv_show_name}/season_#{season}/"
    symlink = "#{output}/#{tv_show_name}/season_#{season}/episod_#{episod}"
  end
  puts symlink
  if (!File.exists?(dir))
    FileUtils.mkdir_p(dir)
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
        if (/(.*)S(\d+)\s*E(\d+)/.match(dir))
          tv_show_name = $1
          season_nb = $2
          episod_nb = $3
          tv_show_name.gsub!('.', ' ')
          tv_show_name.gsub!('-', ' ')
          tv_show_name.gsub!(/\s+/, ' ')
          if (/(.*)\s+/.match(tv_show_name))
            tv_show_name = $1
          end
          push_to_output(full_path, tv_show_name, season_nb, options[:output_dir], episod_nb)
          next
        end

        if (/(.*)S(aison|eason)?\s*(\d)+.*/.match(dir))
          tv_show_name = $1
          season_nb = $3
          tv_show_name.gsub!('.', ' ')
          tv_show_name.gsub!('-', ' ')
          tv_show_name.gsub!(/\s+/, ' ')
          if (/(.*)\s+/.match(tv_show_name))
            tv_show_name = $1
          end
          push_to_output(full_path, tv_show_name, season_nb, options[:output_dir])
          next
        end
      end
    end
  }
end

scan(options) # first time

notifier = INotify::Notifier.new
notifier.watch(options[:scan_dir], :moved_to, :create){scan(options)}

notifier.run
