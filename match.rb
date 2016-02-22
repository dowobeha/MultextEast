#!/usr/bin/ruby

files=ARGV

if (files.size < 2)
	puts "Usage:\t#{$0} file_1 file_2 ... file_n"
	exit(1)
end

puts ARGV[0]
