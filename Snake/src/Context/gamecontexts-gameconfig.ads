package GameContexts.GameConfig is
	
	type ZoomIndice is Positive range (1 .. 3);
	
	type KeyMap is array (Key) of Character;
	
	type Config is tagged private
	
	procedure SetUpConfig(ctxt: in out GameContext.Context);
	
	function Color(c: in Config) return Boolean;
	function Zoom(c: in Config) return ZoomIndice;
	function KeyMapped(c: in Config; k Key) return Character;
	
private
	
	type Config is tagged record
		keymap: KeyMap := (
					 Up => 'z',
					 Down => 's',
					 Left => 'q',
					 Right => 'd',
					 Pause => 'p',
					 ExitGame => 'e'
					);
		color: Boolean := False;
		zoom: ZoomIndice := 1;
	end record;
	
	procedure displayConfigPan(ctxt: in GameContext.Context);
	procedure SetUpKeymap(ctxt: in out GameContext.Context);
	
	

end GameContexts.GameConfig;
