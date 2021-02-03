with GameContext;
with Snake;
with Utility; use Utility;
package Field is

	type Field is tagged private;

	function CreatField(ctxt: in out GameContext.Context) return Field;

	type FieldElem is (Empty, Wall, Space);
	function Char(elem: FieldElem) return Character;

	function Check(f: in out Field; s: in out Snake.Snake) return Boolean;
	procedure Paint(f: in Field);
	procedure DisplayPt(f: in Field);

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
