require_relative 'move'
require_relative 'special_hash'

	# Lists of moves
	@this_layer = []
	@next_layer = nil
	@start = nil	# Where we're starting
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

startTime = Time.now
#  ========== DIFFERENT APPROACHES ==========




# #  ========== Brute force alone ==========

# # with 3 pegs 3 discs = 1272 tests
# # with 3 pegs 4 discs = 3616094 tests
# # with 4 pegs 3 discs = 511 tests
# # with 4 pegs 4 discs = 494343 tests
# while true
# 	# Prepare the next layer
# 	@next_layer = []
# 	# And fill with each next possible move
# 	@this_layer.each do |m|
# 		# The * makes it push each move individually, instead of an array of moves
# 		@next_layer.push *m.all_moves
# 	end

# 	puts "Layer: " + @next_layer.count.to_s

# 	# Go through and see if there's a win anywhere
# 	@next_layer.each do |m|
# 		totalTests += 1
# 		if m == @finish		# Test using our overridden ==
# 			@finish = m
# 			puts "Winner!"
# 			is_won = true
# 			break
# 		end
# 	end
# 	break if is_won

# 	@this_layer = @next_layer
# end




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



# 75 times faster with 5 pegs 5 discs, and with more pegs / discs, exponentially better

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
# 				@moves[thisHash] = nm
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










# #  ========== Brute force plus plus PLUS ... ==========
# #  don't fold back into where we've already been
# #  test for previous match or win using our own cool hash
# #  use our own special hash all around

# # Using our own hash costs us 3% in perf... But it's easier to visualize
# # And we've wrapped the finish test into the next_layer loop
# # Which made it more than twice as fast!!!

# # with 3 pegs 3 discs = 24 tests, avoided 30
# # with 3 pegs 4 discs = 70 tests, avoided 114
# # with 4 pegs 3 discs = 55 tests, avoided 219
# # with 4 pegs 4 discs = 255 tests, avoided 1161
# # with 5 pegs 5 discs = 3124 tests, avoided 25652

# # This time our master list of moves is stored in a hash
# # so we can find stuff in it very quickly
# @moves = SpecialHash.new
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
# 			addIt = false
# 			if hashEntry
# 				if !hashEntry.include?(nm)	# Is this an array that doesn't yet include what we're looking for?
# 					addIt = true
# 				end
# 			else
# 				addIt = true	# Will probably not reach this point ever
# 			end
# 			if addIt
# 				@moves[thisHash] = nm
# 				@next_layer.push nm
# 				# Go through and see if this is a win
# 				if thisHash == finishHash #&& nm == @finish
# 					@finish = nm
# 					puts "Winner!"
# 					is_won = true
# 					break
# 				end
# 			end
# 		end
# 		break if is_won
# 	end
# 	break if is_won

# 	puts "Layer: " + @next_layer.count.to_s

# 	@this_layer = @next_layer
# end






# Look forward and backward at the same time
# Wow this is also such a great speed improvement!
# Another 10 to 12 times faster, and less memory usage too

#  ========== Brute force plus plus PLUS ... ==========
#  don't fold back into where we've already been
#  test for previous match or win using our own cool hash
#  use our own special hash all around

# Using our own hash costs us 3% in perf... But it's easier to visualize

# with 3 pegs 3 discs = 24 tests, avoided 30
# with 3 pegs 4 discs = 70 tests, avoided 114
# with 4 pegs 3 discs = 55 tests, avoided 219
# with 4 pegs 4 discs = 255 tests, avoided 1161
# with 5 pegs 5 discs = 3124 tests, avoided 25652

# This time our master list of moves is stored in a hash
# so we can find stuff in it very quickly
@moves = SpecialHash.new
thisHash = @this_layer[0].hash(@numDiscs)
@moves[thisHash] = @this_layer[0]

@this_layer = SpecialHash.new
@this_layer[thisHash] = @moves[thisHash]

fMoves = SpecialHash.new
fThisLayer = SpecialHash.new
fThisLayer[@finish.hash(@numDiscs)] = @finish
fNextLayer = nil
win = nil

sPegs = Array.new(@start.pegs.count)
fPegs = Array.new(@finish.pegs.count)

for i in (0..@start.pegs.count - 1)
	sPegs[i] = @start.pegs[i].first
	fPegs[i] = @finish.pegs[i].first
end

puts sPegs.inspect
puts fPegs.inspect

while @this_layer.count > 0
	# Prepare the next layer
	@next_layer = SpecialHash.new
	# And fill with each next possible move that goes into new territory
	@this_layer.values.flatten.each do |m|	# From this move
		# Maybe faster by undoing this?
		m.all_moves(fPegs).each do |nm|	# Next moves
			thisHash = nm.hash(@numDiscs)		# Test using our custom hash
			hashEntry = @moves[thisHash]
			addIt = false
			if hashEntry
				if !hashEntry.include?(nm)
					addIt = true
				end
			else
				addIt = true
			end
			if addIt
				@moves[thisHash] = nm
				@next_layer[thisHash] = nm
				# Have we found a win condition?
				fThisOne = fThisLayer[thisHash]
				if fThisOne && fThisOne.include?(nm)
					puts "Found a winner!"
					win = [nm, fThisOne[0]]	# Forward and reverse all in one
					is_won = true
					break
				end
			end
		end
		break if is_won
	end
	break if is_won

	puts "Layer: " + @next_layer.count.to_s + " " + @moves.collisions.to_s + " " + @moves.multipleCollisions.to_s

	@this_layer = @next_layer

	# Now the same but in reverse
	# Prepare the next layer
	fNextLayer = SpecialHash.new
	# And fill with each next possible move that goes into new territory
	fThisLayer.values.flatten.each do |m|	# From this move
		m.all_moves(sPegs).each do |nm|	# Next moves
			thisHash = nm.hash(@numDiscs)		# Test using our custom hash
			hashEntry = fMoves[thisHash]
			addIt = false
			if hashEntry
				if !hashEntry.include?(nm)
					addIt = true
				end
			else
				addIt = true
			end
			if addIt
				fMoves[thisHash] = nm
				fNextLayer[thisHash] = nm
				# Have we found a win condition?
				thisOne = fThisLayer[thisHash]
				if thisOne && thisOne.include?(nm)
					puts "Found a winner!"
					win = [fThisOne[nm], nm]	# Forward and reverse all in one
					is_won = true
					break
				end
			end
		end
		break if is_won
	end
	break if is_won

	fThisLayer = fNextLayer

	puts "Reverse Layer: " + fNextLayer.count.to_s + " " + fMoves.collisions.to_s + " " + fMoves.multipleCollisions.to_s + "/" + fMoves.total.to_s

end




# =========== Show the winners =============
elapsed = Time.now - startTime

if !is_won
	puts "Awwww...."
end

puts "Elapsed: " + elapsed.to_s

#puts @moves.keys.inspect
puts "Total tests: " + totalTests.to_s
puts "Avoided: " + avoided.to_s
puts "Converted: " + converted.to_s
puts "Array Avoided: " + arrayAvoided.to_s
puts "Array Added: " + arrayAdded.to_s

sequence = []
# Walk the start sequence sequence to the start
@finish = win[0].parent
if @finish
	while @finish
		sequence.unshift @finish
		@finish = @finish.parent
	end
end
# Walk the finish sequence forwards to the finish
@finish = win[1]
from = win[0].from
to = win[0].to
while @finish
	nextFrom = @finish.to
	nextTo = @finish.from
	@finish.from = from
	@finish.to = to

	sequence.push @finish
	@finish = @finish.parent

	from = nextFrom
	to = nextTo
end
sequence.each do |f|
	puts f.from.to_s + " -> " + f.to.to_s + " " + f.pegs.inspect
end



# Find out how many unique keys exist in the moves hash
puts "You want to maximize this!" + @moves.keys.count.to_s + " / " + @moves.values.flatten.count.to_s
