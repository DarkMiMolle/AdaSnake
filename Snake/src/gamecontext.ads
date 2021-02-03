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


	-- Config
	procedure SetUpConfig(ctxt: in out Context);

	function Color(c: in Configuration) return Boolean;
	function Zoom(c: in Configuration) return ZoomIndice;
	function KeyMapped(c: in Configuration; k: Key) return Character;


	-- GameInfo
	procedure SetUpGameInfo(ctxt: in out Context);

	function Running(g: in GameInfo) return Boolean;
	function Pausing(g: in GameInfo) return Boolean;
	procedure StopGame(g: in out GameInfo; reason: GameStopedInfo);


	-- Context
	function CreatContext(width, height: SizeTerm) return Context;

	function MaxWidth(ctxt: in Context) return SizeTerm;
	function MaxHeight(ctxt: in Context) return SizeTerm;
	function Config(ctxt: in Context) return Configuration'Class; -- to make the dispatching possible
	function Game(ctxt: in out Context) return access GameInfo'Class; -- to make the dispatching possible
	-- return *GameInfo, we want to be able to modify it
	-- not: to return the access to the GameInfo, we must use: 'Access or 'Unchecked_Access
	-- the in out allows us to return a non const access.

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
