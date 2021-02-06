with Ada.Strings.Unbounded;
with Utility; use Utility;
package GameContext is
	-- it is unfortunatly not possible to separate package in multiple files.
	-- The GameContext must define the Context which have the Config and the GameInfo, both of them need the Context to be set up.
	package Str renames Ada.Strings.Unbounded;
	use Str;

	procedure displayMenu;

	type Configuration is tagged private;
	type GameInfo is tagged private;
	type Context is tagged private;
	-- they aren't tagged because we want inherits them, but because we want to be able to use the dot notation.

	type Key is (Up, Down, Left, Right, Pause, ExitGame);
	type KeyMap is array (Key) of Character;
	type ZoomIndice is new Positive range 1 .. 3;
	type Level is ( Lv1, Lv2, LvCustom);

	type GameStopedInfo is (Processing, LostSnakeEatItself, LostSnakeOnWall, Stoped);

	function G_Game(ctxt: Context) return GameInfo'Class with Ghost;

	-- Config
	procedure SetUpConfig(ctxt: in out Context);
	--

	function Color(c: in Configuration) return Boolean;
	function Zoom(c: in Configuration) return ZoomIndice;
	function KeyMapped(c: in Configuration; k: Key) return Character;


	-- GameInfo
	procedure SetUpGameInfo(ctxt: in out Context);

	function Running(g: in GameInfo) return Boolean;
	function Pausing(g: in GameInfo) return Boolean
		with 	Pre => g.Running;
	procedure StopGame(g: in out GameInfo; reason: GameStopedInfo)
		with 	Pre => g.Running,
				Post => not g.Running;
	procedure Pause(g: in out GameInfo)
		with 	Pre => g.Running,
				Post => g.Running and g.Pausing /= g.Pausing'Old;


	-- Context
	function CreatContext(width, height: SizeTerm) return Context
		with 	Pre => Float(width)/Float(height) >= 0.5 and width/height <= 2 and width >= 20 and height >= 10 and width < SizeTerm'Last - 3 and height < SizeTerm'Last - 3,
				Post => CreatContext'Result.MaxWidth = width and CreatContext'Result.MaxHeight = height and CreatContext'Result.G_Game.Running;

	function MaxWidth(ctxt: in Context) return SizeTerm;
	function MaxHeight(ctxt: in Context) return SizeTerm;
	function Config(ctxt: in Context) return Configuration'Class; -- to make the dispatching possible
	function Game(ctxt: in out Context) return access GameInfo'Class -- to make the dispatching possible
		with Post => ctxt.Game /= null;
	-- return *GameInfo, we want to be able to modify it
	-- note: to return the access to the GameInfo, we must use: 'Access or 'Unchecked_Access
	-- the in out allows us to return a non const access.

	procedure EndGame(ctxt: in Context; score: Integer)
		with	Pre => not ctxt.G_Game.Running;
private

	type Configuration is tagged record
		keymapping: KeyMap := (
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
		running: GameStopedInfo := Stoped;
		pausing: Boolean := False;
		lv: Level := Lv1;
		lvRef: Unbounded_String; -- or Ada.File. to the .snake.sv
	end record;

	type Context is tagged record
		maxWidth, maxHeight: SizeTerm;
		conf: Configuration;
		game: aliased GameInfo; -- aliased means that it is store on the stack (and then has an address) instead of on a register
	end record;

	procedure ClearMenu(ctxt: in Context);
	procedure displayConfigPan(ctxt: in Context);
	procedure SetUpKeymap(ctxt: in out Context);
	procedure displayPlayPan;

end GameContext;
