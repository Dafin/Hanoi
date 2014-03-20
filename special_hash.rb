class SpecialHash < Hash
	attr_accessor :total, :collisions, :multipleCollisions

	def initialize
		@total = 0
		@collisions = 0
		@multipleCollisions = 0
	end

	def []= (k,v)
		e = self.fetch(k,nil)
		@total += 1
		if e
			if e.kind_of?(Array)
				e.push(v)
				@multipleCollisions += 1
			else
				# Assigning multiple times creates an array of stuff
				self.store(k,[e,v])
				@collisions += 1
			end
		else
			self.store(k,v)
		end
	end

	# Always return an array of stuff
	def [] (k)
		v = self.fetch(k,nil)
		if v.kind_of?(Array)
			return v
		else
			return [v]
		end
	end

end
