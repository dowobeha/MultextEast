#!/usr/bin/ruby

require 'set'



def split(token)
	return token.sub("Osrs", "Osr").split("#")
end

def isID(token)
	return (token.start_with?("orwl") and token.include?("#"))
end

def read(file)
	return File.read(file).gsub("\t"," ").gsub("\n",' ').gsub("\r",' ').gsub(/\s+/, " ").gsub("> <","><").gsub("<","\n<").gsub(">",">\n").split("\n")
end

def language(file)
	if file =~ /orwl-(..)\.xml/
		return $1
	else
		return nil
	end
end



file_names=ARGV

if (file_names.size < 2)
	puts "Usage:\t#{$0} file_1 file_2 ... file_n"
	exit(1)
end

all_ids=Hash.new{|k,v| k[v]=Set.new}

file_names.each{|alignment_file|
	read(alignment_file).each{|line|
		ids=Set.new
		line.gsub(/"/, " ").split.each{ |token|
			if isID(token)
				ids.add(token)
			end
		}
		ids.each{|id1|
			ids.each{|id2|
				all_ids[id1].add(id2)
			}
		}
	}
}

visited=Hash.new
all_ids.each{|k,set| visited[k]=false }

def still_merging(id_map)
	id_map.each{|k,v| return true if v==true}
	return false
end

while (still_merging(visited))
	all_ids.sort.each{|id1,set|
		unless visited[id1]
			#puts "#{id1}\t<link targets=\"#{all_ids[id1].to_a.sort.join(" ")}\">"
			set.each{|id2|
				unless all_ids[id2].include?(id1)
					all_ids[id2].add(id1)
					visited[id1]=false
				end
			}
			visited[id1]=true
		end
	}
end

visited2=Hash.new{|k,v| k[v]=false}
all_ids.sort.each{|id1,set|
	unless visited2[id1]
		puts "#{id1}\t<link targets=\"#{all_ids[id1].to_a.sort.join(" ")}\">"
		set.each{|id2| visited2[id2]=true }
	end
}
