with GameContexts;
package Snake is

	type Snake is tagged private;
	
	function Creat(ctxt: in out GameContexts.Context) return Snake;
	
private
	
	type Snake is tagged record
		ctxt: access GameContexts.Context;
	end record;
	

end Snake;
