with Interfaces.C.Strings; use Interfaces.C;
package body Utility is
	
	-- API body
	procedure Print(str: String; from: Position := (-1, -1)) is
		s: Strings.chars_ptr := Strings.New_String(str);
	begin
		C_print_at(s, int(from.x), int(from.y));
		Strings.Free(s);
	end Print;
	
	procedure MoveTo(x, y: Integer) is
	begin
		C_move_to(int(x), int(y));
	end MoveTo;
	
	procedure SetColor(c: ColorName) is
	begin
		C_set_color(int(ColorName'Pos(c)));
	end SetColor;
	

end Utility;
