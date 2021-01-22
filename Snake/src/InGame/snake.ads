with GameContext;
with Utility; use Utility;
package Snake is
	
	type Snake is tagged private;
	
	package Direction is
		type Dir is new Integer range -2 .. 2;
		Up: constant Dir := -1;
		Down: constant Dir := 1;
		Left: constant Dir := -2;
		Right: constant Dir := 2;
	end Direction;
	
	function NextPosFrom(dir: constant Direction; pos: Position) return Position;
	
	function Creat(ctxt: in out GameContext.Context) return Snake;
	
	procedure Display(s: in Snake);
	procedure Hide(s: in Snake);
	
	procedure Move(s: in out Snake);
	procedure Pos(s: in out Snake; p: Position);
	function Pos(s: in Snake) return Position;
	procedure ChangeDir(s: in out Snake; dir: constant Direction.Dir);
	
	procedure AddPoint(s: in out Snake);
	function Score(s: in out Snake) return Integer;
	
private
	type SnakeElem is tagged record
		zoom: GameContext.ZoomIndice;
		pos: Position;
		color: ColorName;
	end record;
	
	function Pos(elem: in SnakeElem) return Position;
	procedure Display(elem: in SnakeElem);
	procedure Hide(elem: in SnakeElem);
		
	type Snake is tagged record
		ctxt: access GameContext.Context;
		elems: VectorPos;
		dir: Direction.Dir;
	end record;
	

end Snake;
