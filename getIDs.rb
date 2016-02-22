#!/usr/bin/ruby

require 'set'

ids=Hash.new{|k,v| k[v]=Set.new}
lines=Hash.new
paragraphs=Hash.new

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

alignment_file=ARGV[0]

read(alignment_file).each{|line|
	unless line =~ /<^!--/
		line.gsub(/"/, " ").split.each{ |token|
			if isID(token)
				file,id = split(token)
				ids[file].add(id)
			end
		}
	end
}




# At this point, we now know all of the valid IDs for each language


if (true)
	
	language="orwl-en.xml"

	STDERR.print "Loading paragraph tags from #{language}\t..."

	most_recent_paragraph_id=""
	paragraph_counter=0

	read(language).each{|line|
	
		if (most_recent_paragraph_id.empty? && line =~ /^<p xml:id="(.*)"[^>]*>/)
			STDERR.puts "WARNING: Adjacent paragraph blocks at\t#{line}" unless most_recent_paragraph_id.empty?
			most_recent_paragraph_id = $1
			paragraph_counter += 1
		elsif (most_recent_paragraph_id.empty? && line =~ /^<quote xml:id="(.*)"[^>]*>/)
			STDERR.puts "WARNING: Adjacent paragraph blocks at\t#{line}" unless most_recent_paragraph_id.empty?
			most_recent_paragraph_id = $1
			paragraph_counter += 1
		elsif (line =~ /^<[^ ]* xml:id="(.*)"[^>]*>/)
			id=$1
			if (ids[language].include?(id) && !most_recent_paragraph_id.empty?)
				paragraphs[language+'#'+id]=paragraph_counter
				most_recent_paragraph_id=""
			end
		end
	
	}

	STDERR.puts "\tread #{paragraph_counter} paragraph tags"
end


ids.each_pair{|language,set|
	STDERR.print "Loading #{set.size} sentences from #{language}\t..."

	counter=0
	result=""
	started=false
	read(language).each{|line|

		if (line =~ /^<([^ ]*) xml:id="(.*)"[^>]*>/)
			tag=$1
			id=$2
			if (ids[language].include?(id))
				started=true
				result+="\n" + language+"\##{id}\t"
			elsif tag=="s"
#				STDERR.puts "WARNING: Unaligned <s> tag:\t#{line}"
			end
		elsif (started==true && ! line.start_with?("<") && !line.empty?)
			result+=line.strip + " "
		end
	}

	result.gsub(/  /, " ").gsub(/ \n/, "\n").split("\n").each{|line|
		if (! (line.empty? || line.strip.empty?))
			id,sentence = line.split("\t")
			lines[id]=sentence.strip
			counter+=1
		end
	}

	STDERR.puts "\tread #{counter} sentences"

}

align_id=1
most_recent_para=-1
read(alignment_file).each{|line|
	unless line =~ /<^!--/
		ids=Array.new
		alignment=""
		line.gsub(/"/, " ").split.each{ |token|
			if isID(token)
				ids.push(token)
			elsif token.include?(":")
				alignment=token
			end
		}
		para=-1
		ids.each{|id| 
			if paragraphs.key?(id)
				para=paragraphs[id]
				most_recent_para=para
			end
		}
		puts "<p id=\"#{para}\">" if para>0
		unless ids.empty?
			STDERR.puts "%04d" % most_recent_para
			puts "<aligned_block id=\"#{align_id}\" alignment=\"#{alignment}\">"; align_id += 1
			ids.each{|token|
			 	file,id = split(token)
				puts "<s id=\"#{id}\" language=\"#{language(file)}\">#{lines[token]}"
			}
		end
	end
}
