package GameContexts.GameInfo is

	type Level is ( Lv1, Lv2, LvCustom);
	
	type GameInfo is private;
	
	procedure SetUpGameInfo(ctxt: in out GameContext.Context);
	
	function Running(g: in GameInfo) return Boolean;
	function Pausing(g: in GameInfo) return Boolean;
	
	procedure StopGame(g: in out GameInfo);
	
private
	
	type GameInfo is tagged record
		running: Boolean := False;
		pausing: Boolean := False;
		level: Level := Lv1;
		lvRef: String; -- TODO: find a way to store variadic length string
	end record;
	
	procedure displayPlayPan;
	

end GameContexts.GameInfo;
