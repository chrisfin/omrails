module ViewsHelper

	def store_rank(pin, rank)
	    session[:ranks] = { pin => rank }
	end
end
