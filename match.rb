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

languages=Set.new


all_ids=Hash.new{|k,v| k[v]=Set.new}

file_names.each{|alignment_file|
	read(alignment_file).each{|line|
		ids=Set.new
		line.gsub(/"/, " ").split.each{ |token|
			if isID(token)
				ids.add(token)
				file,rest = split(token)
				languages.add(file)
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

def recursivelyCalculateUnion(id1, id_map, visited_map, results_set)
	#puts "\n\nrecursivelyCalculateUnion for #{id1}"
	id_map[id1].each{|id2|
		#print "Adding #{id2} to results_set\t#{results_set.to_a.to_s}"
		results_set.add(id2)
		#puts "\t#{results_set.to_a.to_s}"
	}
	visited_map[id1]=true
	id_map[id1].each{|id2|
		unless visited_map[id2] == true
			recursivelyCalculateUnion(id2, id_map, visited_map, results_set)
		end
	}
	return results_set
end

vis=Hash.new{|k,v| k[v]=false}
all_ids.each{|id1,set|
	unless vis[id1]==true
		union = recursivelyCalculateUnion(id1, all_ids, vis, Set.new)
		union.each{|id2|
			all_ids[id2]=union
		}
	end	
}

puts "<?xml version=\"1.0\" encoding=\"us-ascii\"?>"
puts "<linkGrp xmlns=\"http://www.tei-c.org/ns/1.0\" type=\"alignment\" corresp=\"#{languages.to_a.sort.join(" ")}\">"
vis2=Hash.new{|k,v| k[v]=false}
all_ids.each{|id1,set|
	unless vis2[id1]==true
		alignment=Hash.new{|k,v| k[v]=0}
		all_ids[id1].to_a.each{|id|
			file,value=split(id)
			alignment[file] += 1
			#puts "alignment[#{file}] = #{alignment[file]}"
		}
		print "<link n=\""
		print languages.to_a.sort.map{|file_name| alignment[file_name]}.join(":")
		puts "\" targets=\"#{all_ids[id1].to_a.sort.join(" ")}\">"
		set.each{|id2| vis2[id2]=true }
	end	
}
puts "</linkGrp>"
