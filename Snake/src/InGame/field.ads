with GameContexts;
with Snake; use Snake;
package Field is

	type Field is tagged private;
	
	function Check(f: in out Field; s: in out Snake) return Boolean;
	
private
	type Field is tagged record
		ctxt: access GameContexts.Context;
	end record;
	

end Field;
