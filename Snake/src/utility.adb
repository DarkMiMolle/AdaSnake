with Interfaces.C.Strings; use Interfaces.C;
package body Utility is
	
	-- API body
	procedure Print_at(str: String; from: Position := (-1, -1)) is
		s: Strings.chars_ptr := Strings.New_String(str);
	begin
		C_print_at(s, int(from.x + StartTerm), int(from.y));
		Strings.Free(s);
	end Print_at;
	
	procedure Print(str: String; x: SizeTerm; y: SizeTerm) is
		s: Strings.chars_ptr := Strings.New_String(str);
	begin
		C_print_at(s, int(x + StartTerm), int(y));
		Strings.Free(s);
	end Print;
	
	procedure MoveTo(x, y: Integer) is
	begin
		C_move_to(int(x + StartTerm), int(y));
	end MoveTo;
	
	procedure SetColor(c: ColorName) is
	begin
		C_set_color(int(ColorName'Pos(c)));
	end SetColor;
	

end Utility;
