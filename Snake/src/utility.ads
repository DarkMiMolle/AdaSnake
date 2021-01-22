with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
package Utility is

	type Pos is record
		x, y: Integer;
	end record;




	type ColorName is (Blue, Red, Green, Brown, Black);
	function Color(c: ColorName) return int;

	-- ADA API for the private C function linked, used to navigate in the term
	procedure Print(str: String; from: Pos := (-1, -1));
	procedure Move_to(x, y: Integer);
	procedure SetColor(c: ColorName);


end Utility;
