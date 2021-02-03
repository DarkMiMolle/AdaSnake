with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with Ada.Containers.Vectors; use Ada.Containers;
package Utility is

	type SizeTerm is new Integer range 0 .. 100;

	StartTerm: constant SizeTerm := 2;

	type Position is record
		x, y: Integer;
	end record;

	package VectorPosPkg is new Vectors(Natural, Position);
	subtype VectorPos is VectorPosPkg.Vector;


	type ColorName is (Blue, Red, Green, Brown, Black, None);

	-- ADA API for the private C function linked, used to interact in the term
	procedure Print_at(str: String; from: Position := (-1, -1));
	procedure Print(str: String; x: SizeTerm; y: SizeTerm);
	procedure Print(str: String);
	procedure MoveTo(x, y: SizeTerm);
	procedure SetColor(c: ColorName);
	procedure EraseConsole();

private
	procedure C_print_at(str: Strings.chars_ptr; x: int; y: int)
	  with Import => True, Convention => C, External_Name => "print_at";

	procedure C_move_to(x: int; y: int)
	  with Import => True, Convention => C, External_Name => "move_to";

	procedure C_set_color(c: int)
	  with Import => True, Convention => C, External_name => "set_color";
	
	procedure C_erase_console()
	  with Import => True, Convention => C, External_name => "erase_console";

end Utility;
