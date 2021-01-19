package GameContext is

	-- needs: Snake, Field, Point
 -- Snake and Point need Field
	
	type Context is private
	
	type Config is private
	
	type GameInfo is private
	
	type Key is (Up, Down, Left, Right, Pause, ExitGame);
	
	type Keymap is array (Key) of Character;
	
	-- Context
	
	function config(self: in Context) return Config;
	
	function game(self: in Context) return GameInfo;
	
	-- Config
	function keymap(self: in Config) return Keymap;
	procedure keymap(self: in out Config; k: Key, c: Character);
	
	function color(self: in Config) return Boolean;
	procedure color(self: in out Config, state: Boolean);
	
	-- get/set for configuration
	
	-- GameInfo
	function running(self: in GameInfo) return Boolean;
	procedure stop_game(self: in out GameInfo);
	
private
	type Config is tagged record
	end record;
	
	
	type GameInfo is tagged record
	end record;
	
	type Context is tagged record
	end record;
	

end GameContext;
