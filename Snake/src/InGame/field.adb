--with utility; use utility;

package body Field is
    function CreatField(ctxt: in out GameContext.Context) return Field is
    f2D : Field2D(ctxt.maxWidth, ctxt.maxHeight);
    begin
        for x := 0 in ctxt.maxWidth loop
	    for y := 0 in ctxt.maxHeight loop
		if y = 0 or y = ctxt.maxHeight or x = 0 or ctxt.maxWidth then
		    f2D(x, y) = Wall;
		else
		    f2D(x, y) = Space;
		end if;
	    end loop;
        end loop;
	return (ctxt, (StartTerm + 2, 2), (StartTerm + 10, 20), f2D);
    end CreatField;

    function Char(elem: FieldElem) return Character;

    function Check(f: in out Field; s: in out Snake.Snake) return Boolean;
    procedure Paint(f: in Field);
    procedure DisplayPt(f: in Field);
   
end Field;
