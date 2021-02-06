with Ada.Containers.Vectors; use Ada.Containers;
with GameContext;
with Utility; use Utility;
package Snake is

	type Snake is tagged private;

	package Direction is
		type Dir is new Integer range -2 .. 2 with Static_Predicate => Dir /= 0;
		Up: constant Dir := -1;
		Down: constant Dir := 1;
		Left: constant Dir := -2;
		Right: constant Dir := 2;
	end Direction;
	function NextPosFrom(dir: in Direction.Dir; pos: Position) return Position
		with 	Post => pos /= NextPosFrom'Result;


	function G_GameRunning(s: in Snake) return Boolean with Ghost;
	function G_Dir(s: in Snake) return Direction.Dir with Ghost;
	function G_Score(s: Snake) return Integer with Ghost;


	function Creat(ctxt: in out GameContext.Context) return Snake
		with 	Pre => ctxt.Game.Running and ctxt'Unchecked_Access /= null;

	procedure Display(s: in Snake)
		with 	Pre => s.G_GameRunning;

	procedure Move(s: in out Snake)
		with 	Pre => s.G_GameRunning,
				Post => s.Pos'Old /= s.Pos and s.Pos = NextPosFrom(s.G_Dir, s.Pos);
	procedure Pos(s: in out Snake; p: Position)
		with 	Post => s.Pos = p;
	function Pos(s: in Snake) return Position;
	procedure ChangeDir(s: in out Snake; dir: in Direction.Dir)
		with 	Post => Integer(s.G_Dir) = Integer(dir);

	procedure AddPoint(s: in out Snake)
		with 	Post => s.G_GameRunning and s.Score = s'Old.G_Score + 1;
	function Score(s: in Snake) return Integer;

private

	type SnakeElem is tagged record
		pos: Position;
	end record;

	function Pos(elem: in SnakeElem) return Position;
	procedure Pos(elem: in out SnakeElem; p: Position);
	procedure Display(elem: in SnakeElem; zm: GameContext.ZoomIndice; cl: ColorName);
	procedure Hide(s: in SnakeElem; zm: GameContext.ZoomIndice);

	package VectorSnakeElemPkg is new Vectors(Natural, SnakeElem);
	subtype VectorSnakeElem is VectorSnakeElemPkg.Vector;

	type Snake is tagged record
		ctxt: access GameContext.Context;
		elems: VectorSnakeElem := VectorSnakeElemPkg.to_Vector(0);
		dir: Direction.Dir;
	end record;


end Snake;
