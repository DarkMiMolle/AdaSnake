package GameContext is
	-- it is unfortunatly not possible to separate package in multiple files.
	-- The GameContext must define the Context which have the Config and the GameInfo, both of them need the Context to be set up.
	
	type Config is tagged private;
	type GameInfo is tagged private;
	type Context is tagged aliased private;
	
	type ZoomIndice is new Positive range 1 .. 3;
	type KeyMap is array (Key) of Character;
	type Level is ( Lv1, Lv2, LvCustom);
	
	
	-- Config
	procedure SetUpConfig(ctxt: access Context);
	
	function Color(c: in Config) return Boolean;
	function Zoom(c: in Config) return ZoomIndice;
	function KeyMapped(c: in Config; k: Key) return Character;
	
	
	-- GameInfo
	procedure SetUpGameInfo(ctxt: in out Context);
	
	function Running(g: in GameInfo) return Boolean;
	function Pausing(g: in GameInfo) return Boolean;
	procedure StopGame(g: in out GameInfo);
	
	
	-- Context
	function CreatContext(width, height: Positive) return Context;
	
	function MaxWidth(ctxt: in Context) return Positive;
	function MaxHeight(ctxt: in Context) return Positive;
	function Config(ctxt: in Context) return Config;
	function Game(ctxt: in out Context) return access GameInfo; 
	-- return *GameInfo, we want to be able to modify it
	-- not: to return the access to the GameInfo, we must use: 'Access or 'Unchecked_Access
	-- the in out allows us to return a non const access.
	
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
	
	type GameInfo is tagged record
		running: Boolean := False;
		pausing: Boolean := False;
		level: Level := 1;
		lvRef: String; -- or Ada.File. to the .snake.sv
	end record;
	
	type Context(maxWidth, maxHeight: Positive) is tagged record
		conf: Config;
		game: aliased GameInfo; -- aliased means that it is store on the stack (and then has an address) instead of on a register
	end record;
	
	procedure displayConfigPan(ctxt: in Context);
	procedure SetUpKeymap(ctxt: in out Context);
	procedure displayPlayPan;

end GameContext;
