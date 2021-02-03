with Ada.Containers.Vectors; use Ada.Containers;
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
	
	function NextPosFrom(dir: in Direction.Dir; pos: Position) return Position;
	
	function Creat(ctxt: in out GameContext.Context) return Snake;
	
	procedure Display(s: in Snake);
	
	procedure Move(s: in out Snake);
	procedure Pos(s: in out Snake; p: Position);
	function Pos(s: in Snake) return Position;
	procedure ChangeDir(s: in out Snake; dir: in Direction.Dir);
	
	procedure AddPoint(s: in out Snake);
	function Score(s: in out Snake) return Integer;
	
private

	type SnakeElem is tagged record
		pos: Position;
	end record;
	
	package VectorSnakeElemPkg is new Vectors(Natural, SnakeElem);
	subtypes VectorSnakeElem is VectorSnakeElemPkg.Vector;
	
	
	function Pos(elem: in SnakeElem) return Position;
	procedure Pos(elem: in SnakeElem; p: Position);
	procedure Display(elem: in SnakeElem; zm: GameContext.ZoomIndice; cl: ColorName);
	procedure Hide(elem: in SnakeElem; zm: GameContext.ZoomIndice);
		
	type Snake is tagged record
		ctxt: access GameContext.Context;
		elems: VectorSnakeElem := VectorSnakeElemPkg.to_Vector(4);
		dir: Direction.Dir;
	end record;
	

end Snake;
