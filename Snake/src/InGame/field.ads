with GameContext;
with Snake;
with Utility; use Utility;
package Field is

	type Field is tagged private;

	--function G_CheckRepresentation(f: Field) return Boolean with Ghost;

	function CreatField(ctxt: in out GameContext.Context) return Field
		with 	Pre => ctxt'Unchecked_Access /= null,
				Post => True; --for all e in CreatField'Return.G_Representation ;

	type FieldElem is (Empty, Wall, Space);
	function Char(elem: FieldElem) return Character;

	function G_Context(f: in Field) return access GameContext.Context with Ghost;
	function G_GameRunning(f: in Field) return Boolean with Ghost, Post => f.G_Context /= null;

	function Check(f: in out Field; s: in out Snake.Snake) return Boolean
		with	Pre => f.G_GameRunning;
	procedure Paint(f: in Field);
	procedure DisplayPt(f: in Field)
		with	Pre => f.G_GameRunning;
	procedure NextPoint(f: in out Field);
	-- pre: game running and (snake.Pos = f.Point or game pausing)
	-- post: (pre) and f.Point on Space and f.Point not on Snake.Pos
	procedure HidePt(f: in Field);
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
