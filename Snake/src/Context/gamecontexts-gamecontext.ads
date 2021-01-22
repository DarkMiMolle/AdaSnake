package GameContexts.GameContext  is

	type Context is tagged private;
	
	function CreatContext(width, height: Positive) return Context;
	
	function MaxWidth(ctxt: in Context) return Positive;
	function MaxHeight(ctxt: in Context) return Positive;
	function Config(ctxt: in Context) return Config;
	function Game(ctxt: in out Context) return access GameInfo; 
	-- return *GameInfo, we want to be able to modify it
	-- not: to return the access to the GameInfo, we must use: 'Access or 'Unchecked_Access
	-- the in out allows us to return a non const access.
	
private
	type Context(maxWidth, maxHeight: Positive) is tagged record
		conf: Config;
		game: aliased GameInfo; -- aliased means that it is store on the stack (and then has an address) instead of on a register
	end record;
   

end GameContexts.GameContext ;
