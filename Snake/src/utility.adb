with Interfaces.C.Strings; use Interfaces.C;
with Ada.Text_IO; use Ada.Text_IO;
package body Utility is

	-- API body
	procedure Print_at(str: String; from: Position) is
		s: Strings.chars_ptr := Strings.New_String(str);
	begin
		C_print_at(s, int(PosTerm(from.x) + StartTerm), int(from.y));
		Strings.Free(s);
	end Print_at;

	procedure Print_at(str: String; x: PosTerm; y: PosTerm) is
		s: Strings.chars_ptr := Strings.New_String(str);
	begin
		C_print_at(s, int(x + StartTerm), int(y));
		Strings.Free(s);
	end Print_at;

	procedure Print(str: String) is
	begin
		Put(str);
	end Print;

	procedure MoveTo(x, y: PosTerm) is
	begin
		C_move_to(int(StartTerm + x), int(y));
	end MoveTo;

	procedure SetColor(c: ColorName) is
		colorInt: Integer := 0;
	begin
		colorInt := (case c is
			when Black => 30,
			when Red => 31,
			when Blue => 34,
			when Green => 32,
			when Brown => 33,
			when others => 0);
		C_set_color(int(colorInt));
	end SetColor;

	procedure EraseConsole is
	begin
		C_erase_console;
	end EraseConsole;


end Utility;
