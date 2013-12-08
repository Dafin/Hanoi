require_relative 'move'

	# Lists of moves
	@this_layer = []
	@next_layer = nil
	@finish = nil		# What our goal is

	# Read in all values and create structures with them

require_relative 'initialize'

# ===== Our goal: =====
# Find each possible move that doesn't in any way fold back on a previous condition,
# and doesn't move from the place that was just moved to in the last round

totalTests = 0
avoided=0	# How many paths were nixed along the way
is_won = false

# Metrics only for hash version
converted = 0	# How many are converted from a move entry to an array
arrayAvoided = 0	# How many arrays we used to avoid work
arrayAdded = 0	# How many extra entries were added to an existing array

#  ========== DIFFERENT APPROACHES ==========

#  ========== Brute force alone ==========

# with 3 pegs 3 discs = 1272 tests
# with 3 pegs 4 discs = 3616094 tests
# with 4 pegs 3 discs = 511 tests
# with 4 pegs 4 discs = 494343 tests
while true
	# Prepare the next layer
	@next_layer = []
	# And fill with each next possible move
	@this_layer.each do |m|
		# The * makes it push each move individually, instead of an array of moves
		@next_layer.push *m.all_moves
	end

	puts "Layer: " + @next_layer.count.to_s

	# Go through and see if there's a win anywhere
	@next_layer.each do |m|
		totalTests += 1
		if m == @finish		# Test using our overridden ==
			@finish = m
			puts "Winner!"
			is_won = true
			break
		end
	end
	break if is_won

	@this_layer = @next_layer
end


# #  ========== Brute force plus ... ==========
# #  don't fold back into where we've already been
# #  SO MUCH FASTER!!!

# # with 3 pegs 3 discs = 24 tests, avoided 30
# # with 3 pegs 4 discs = 70 tests, avoided 114
# # with 4 pegs 3 discs = 55 tests, avoided 219
# # with 4 pegs 4 discs = 255 tests, avoided 1161
# # with 5 pegs 5 discs = 3124 tests, avoided 25652

# # This is a master list of moves so we can recognize any place we
# # fold back into a previously-searched part of the graph
# 	@moves = []
# # Seed move list with the first move
# 	@moves.push *@this_layer

# while @this_layer.count > 0
# 	# Prepare the next layer
# 	@next_layer = []
# 	# And fill with each next possible move that goes into new territory
# 	@this_layer.each do |m|	# From this move
# 		m.all_moves.each do |nm|	# Next moves
# 			if @moves.include? nm		# Test using our overridden ==
# 				avoided += 1
# 			else
# 				@next_layer.push nm
# 				# Keep the overall list of moves filled in
# 				@moves.push nm
# 			end
# 		end
# 	end

# 	puts "Layer: " + @next_layer.count.to_s

# 	# Go through and see if there's a win anywhere
# 	@next_layer.each do |m|
# 		totalTests += 1
# 		if m == @finish
# 			@finish = m
# 			puts "Winner!"
# 			is_won = true
# 			break
# 		end
# 	end
# 	break if is_won

# 	@this_layer = @next_layer
# end


# #  ========== Brute force plus plus ... ==========
# #  don't fold back into where we've already been
# #  test for previous match or win using our own cool hash

# # with 3 pegs 3 discs = 24 tests, avoided 30
# # with 3 pegs 4 discs = 70 tests, avoided 114
# # with 4 pegs 3 discs = 55 tests, avoided 219
# # with 4 pegs 4 discs = 255 tests, avoided 1161
# # with 5 pegs 5 discs = 3124 tests, avoided 25652

# # This time our master list of moves is stored in a hash
# # so we can find stuff in it very quickly
# @moves = {}
# @moves[@this_layer[0].hash(@numDiscs)] = @this_layer[0]
# finishHash = @finish.hash(@numDiscs)

# while @this_layer.count > 0
# 	# Prepare the next layer
# 	@next_layer = []
# 	# And fill with each next possible move that goes into new territory
# 	@this_layer.each do |m|	# From this move
# 		m.all_moves.each do |nm|	# Next moves
# 			thisHash = nm.hash(@numDiscs)		# Test using our custom hash
# 			hashEntry = @moves[thisHash]
# 			if hashEntry
# 				# Need to put an array out here if there is a clash
# 				if hashEntry.kind_of?(Array)
# 					if(hashEntry.include? nm)
# 						arrayAvoided += 1
# 						avoided += 1
# 					else
# 						hashEntry.push nm
# 						@next_layer.push nm
# 						arrayAdded += 1
# 					end
# 				else
# 					# Need to convert from one to an array?
# 					if hashEntry == nm
# 						avoided += 1
# 					else
# 						@moves[thisHash] = [hashEntry,nm]
# 						converted += 1
# 						@next_layer.push nm
# 					end
# 				end
# 			else
# 				@next_layer.push nm
# 				@moves[nm.hash(@numDiscs)] = nm
# 			end
# 		end
# 	end

# 	puts "Layer: " + @next_layer.count.to_s

# 	# Go through and see if there's a win anywhere
# 	@next_layer.each do |m|
# 		totalTests += 1
# 		if m.hash(@numDiscs) == finishHash && m == @finish
# 			@finish = m
# 			puts "Winner!"
# 			is_won = true
# 			break
# 		end
# 	end
# 	break if is_won

# 	@this_layer = @next_layer
# end


# =========== Show the winners =============


if !is_won
	puts "Awwww...."
end

#puts @moves.keys.inspect
puts "Total tests: " + totalTests.to_s
puts "Avoided: " + avoided.to_s
puts "Converted: " + converted.to_s
puts "Array Avoided: " + arrayAvoided.to_s
puts "Array Added: " + arrayAdded.to_s

# Walk the sequence backwards to the start
while @finish
	puts @finish.from.to_s + " -> " + @finish.to.to_s + " " + @finish.pegs.inspect
	@finish = @finish.parent
end
