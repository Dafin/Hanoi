class Move
	attr_accessor :parent, :pegs, :from, :to
	def initialize(parent, numPegs)
		@parent = parent	# A previous move that got me here
		@pegs = Array.new(numPegs)
		# Have each peg start with an empty array
		for i in (0..@pegs.length - 1)
			@pegs[i]=Array.new
		end
		@from = -1
		@to = -1
	end

	def ==(mv)		# Check one against the other
		for i in (0..pegs.length-1)
			if pegs[i] != mv.pegs[i]
				return false
			end
		end
		return true
	end

	# Quickly generate a quasi-unique hash based on where the discs
	# are on the pegs.
	def hash(numDiscs)
		ret = 0
		for i in (0..pegs.length-1)
			for j in (0..pegs[i].length - 1)
				# This is some bitwise manipulation that exclusive-ORs 2 bits
				# for each disc at a unique offset for the disc's peg and position
				# on the peg
				ret ^= ((pegs[i][j] % 7)+1) << (((i*numDiscs + j)%16)<<1)
			end
		end
		# Return a 4-byte FixNum
		# We can't directly instantiate a FixNum, but this should do the trick
		# They range from -2**30 to 2**30-1, so here we're subtracting by 2**30
		(ret-1073741824).to_i
	end

	def clone
		newOne = Move.new(self, self.pegs.count)
		# Copy the pegs over
		for i in (0..pegs.length - 1)
			# And the discs
			newOne.pegs[i] = Array.new(pegs[i].length)
			for j in (0..pegs[i].length - 1)
				newOne.pegs[i][j] = pegs[i][j]
			end
		end
		newOne
	end

	def all_moves
		# We look at each peg, and if there is a disc
		# see where it can move
		result = []
		src_index = 0
		self.pegs.each do |src|
			if src.count > 0	# If there is a disc here
				this_disc = src.last	# Grab the disc itself
				# Look for all possible destination pegs
				dest_index = 0
				self.pegs.each do |dest|
					if this_disc &&	# We actually have a disc!
					 dest != src &&	# Not the same peg
						(dest.last == nil	||	# Empty destination
						 dest.last > this_disc)	# Bigger destination disc
						new_move = self.clone

						new_move.from = src_index
						new_move.to = dest_index
						new_move.pegs[dest_index].push new_move.pegs[src_index].pop	# Actually move the disc
						# Put this valid move in the array of results
						result.push new_move
					end
					dest_index += 1
				end
			end
			src_index += 1  # Add one to our source index
		end
		result
	end

end
