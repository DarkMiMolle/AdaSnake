with Interfaces.C.Strings; use Interfaces.C;
with Ada.Text_IO; use Ada.Text_IO;
package body Utility is
	
	-- API body
	procedure Print_at(str: String; from: Position := (-1, -1)) is
		s: Strings.chars_ptr := Strings.New_String(str);
	begin
		if from.x < 0 or from.y < 0 then
			Put(str);
		else
			C_print_at(s, int(SizeTerm(from.x) + StartTerm), int(from.y));
		end if;
		Strings.Free(s);
	end Print_at;
	
	procedure Print(str: String; x: SizeTerm; y: SizeTerm) is
		s: Strings.chars_ptr := Strings.New_String(str);
	begin
		C_print_at(s, int(x + StartTerm), int(y));
		Strings.Free(s);
	end Print;
	
	procedure Print(str: String) is
	begin
		Put(str);
	end Print;
	
	procedure MoveTo(x, y: SizeTerm) is
	begin
		C_move_to(int(x), int(y));
	end MoveTo;
	
	procedure SetColor(c: ColorName) is
	begin
		C_set_color(int(ColorName'Pos(c)));
	end SetColor;
	

end Utility;
