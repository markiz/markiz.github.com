watch ('.*') {|m| system("jekyll") unless m[0] =~ /^_site/ }
