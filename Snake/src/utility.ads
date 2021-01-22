with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with Ada.Containers.Vectors; use Ada.Containers;
package Utility is

	StartTerm: constant Integer := 2;

	type Position is record
		x, y: Integer;
	end record;

	package VectorPosPkg is new Vectors(Natural, Position);
	subtype VectorPos is VectorPosPkg.Vector;


	type ColorName is (Blue, Red, Green, Brown, Black, None);
	function Color(c: ColorName) return int;

	-- ADA API for the private C function linked, used to navigate in the term
	procedure Print(str: String; from: Position := (-1, -1));
	procedure Move_to(x, y: Integer);
	procedure SetColor(c: ColorName);

private
	procedure C_print_at(str: C.Strings.chars_ptr; x: int; y: int)
	  with Import => True, Convention => C, External_name => "print_at";

	procedure C_move_to(x: int; y: int)
	  with Import => True, Convention => C, External_name => "move_to";

	procedure C_set_color(c: int)
	  with Import => True, Convention => C, External_name => "set_color";

end Utility;
