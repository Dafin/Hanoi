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
		nd = numDiscs - 1
		ret = 0
		for i in (0..pegs.length - 1)
			for j in (0..pegs[i].length - 1)
				# This is some bitwise manipulation that exclusive-ORs 2 bits
				# for each disc at a unique offset for the disc's peg and position
				# on the peg
#				ret ^= ((pegs[i][j] % nd)+1) << (((i*numDiscs + j)%16)<<1)
#				Best value for 8 5 - 13
#				Best for 7 5 - 16
#				Best for 7 5 - 16
				ret ^= ((pegs[i][j] % nd)+1) << (((i*numDiscs + j)%16)<<1)
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

	def all_moves(finish)
			# We look at each peg, and if there is a disc
		# see where it can move
		result = []
		cm1 = self.pegs.count - 1
		for si in (0..cm1)
			src = self.pegs[si]
			if src.count > 0	# If there is a disc here
				this_disc = src.last	# Grab the disc itself
				# Look for all possible destination pegs
				# This speeds things up enormously, especially with lots of pegs or in cases where we're going all from one peg to all another
				# It tests if this disc should be at the root of this destination peg
				hasFoundEmpty = false	# Have we already been working with an empty peg?
				for di in (0..cm1)
					dest = self.pegs[di]
					destLast = dest.last

					# # Previous DRY version
					# if dest != src &&	# Not the same peg
					# 	(destLast == nil	||	# Empty destination
					# 	 destLast > this_disc)	# Bigger destination disc
					# 	root = finish[di]
					# 	if destLast == nil && root != this_disc
					# 		# The only two conditions a disc should be moved to an empty peg are if it's the
					# 		# first empty peg we've tested or this is a root disc and is the real destination
					# 		# for this disc
					# 		next if hasFoundEmpty && root == nil
					# 		hasFoundEmpty = true
					# 	end
					# 	new_move = self.clone
					# 	new_move.from = si
					# 	new_move.to = di
					# 	new_move.pegs[di].push new_move.pegs[si].pop	# Actually move the disc
					# 	# Put this valid move in the array of results
					# 	result.push new_move
					# end

					# Unrolling this has the exact same logic, but makes it 1.3% faster
					if dest != src	# Not the same peg
						if destLast == nil	# Empty destination
							root = finish[di]
							if root != this_disc
								# The only two conditions a disc should be moved to an empty peg are if it's the
								# first empty peg we've tested or this is a root disc and is the real destination
								# for this disc
								next if hasFoundEmpty && root == nil
								hasFoundEmpty = true
							end
							new_move = self.clone
							new_move.from = si
							new_move.to = di
							new_move.pegs[di].push new_move.pegs[si].pop	# Actually move the disc
							# Put this valid move in the array of results
							result.push new_move
						elsif destLast > this_disc	# Bigger destination disc
							new_move = self.clone
							new_move.from = si
							new_move.to = di
							new_move.pegs[di].push new_move.pegs[si].pop	# Actually move the disc
							# Put this valid move in the array of results
							result.push new_move
						end
					end

				end
			end
		end
		result
	end

end
