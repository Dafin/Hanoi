line = [] #string[]
ret = ""

File.open("start.txt", "r") do |infile|
	line = infile.gets.split(' ')
	@numDiscs = line[0].to_i
	numPegs = line[1].to_i

	@start = Move.new(nil, numPegs)
	@finish = Move.new(nil, numPegs)

		# Where the discs all start
	line = infile.gets.split(' ')
	thisDisc = 1
	line.each do |pegNum|
		@start.pegs[pegNum.to_i-1].unshift thisDisc
		thisDisc += 1
	end
		
		# And where they should all end up
	line = infile.gets.split(' ')
	thisDisc = 1
	line.each do |pegNum|
		@finish.pegs[pegNum.to_i-1].unshift thisDisc
		thisDisc += 1
	end

	# Seed the breadth-first layer
	@this_layer.push @start

end	# Close the file being read
