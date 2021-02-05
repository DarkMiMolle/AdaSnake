with GameContext;
with Snake;
with Utility; use Utility;
package Field is

	type Field is tagged private;

	function G_CheckRepresentation(f: Field) return Boolean with Ghost;

	function CreatField(ctxt: in out GameContext.Context) return Field
		with 	Pre => ctxt'Unchecked_Access /= null,
				Post => G_CheckRepresentation(CreatField'Result);

	type FieldElem is (Empty, Wall, Space);
	function Char(elem: in FieldElem) return Character;

	function G_Context(f: in Field) return access GameContext.Context with Ghost;
	function G_GameRunning(f: in Field) return Boolean with Ghost,
	 	Pre => f.G_Context /= null;
	function G_GamePausing(f: in Field) return Boolean with Ghost,
	 	Pre => f.G_Context /= null;
	function G_SnakePos(f: in Field) return Position with Ghost;
	function G_PtPos(f: in Field) return Position with Ghost;
	function G_FieldElemAt(f: Field; pos: Position) return FieldElem with Ghost;

	function Check(f: in out Field; s: in out Snake.Snake) return Boolean
		with	Pre => f.G_GameRunning,
				Post => f.G_GameRunning = (f.G_FieldElemAt(s.Pos) = Space) -- False = False --> True
			and ((f.G_GameRunning and then (f.G_FieldElemAt(f.G_PtPos) = Space and f.G_PtPos /= s.Pos)) or else not f.G_GameRunning);
		-- the last line says: if the game is running the point has moved, else the game is not running anymore
	procedure Paint(f: in Field);
	procedure DisplayPt(f: in Field)
		with	Pre => f.G_GameRunning;
	procedure NextPoint(f: in out Field)
		with	Pre => f.G_GameRunning and (f.G_SnakePos = f.G_PtPos or (f.G_Context /= null and then f.G_Context.Game.Pausing)),
				Post => f.G_PtPos'Old /= f.G_PtPos and f.G_FieldElemAt(f.G_PtPos) = Space and f.G_PtPos /= f.G_SnakePos;
	procedure HidePt(f: in Field)
		with	Pre => f.G_GamePausing;
	-- pre: game pausing
private
	type Field2D is array (SizeTerm, SizeTerm) of FieldElem;

	type Field is tagged record
		width, height: SizeTerm;
		ctxt: access GameContext.Context;
		snakePos: Position;
		ptPos: Position;
		representation: Field2D;
	end record;


end Field;
