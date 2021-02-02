with GameContext;
with Ada.Text_IO; use Ada.Text_IO;
with Utility; use Utility;

procedure Main is
	function init return GameContext.Context is
		w, h: Utility.SizeTerm;
	begin
		Put("Max width of the term: ");
		w := SizeTerm(Integer'Value(Get_Line));
		Put("Max Height of the term: ");
		h := SizeTerm(Integer'Value(Get_Line));
		return GameContext.CreatContext(w, h);
	end init;


	procedure Menu(ctxt: in out GameContext.Context) is
		c: Character;
		selection: Natural := 0;
	begin
		MoveTo(0, 0);
		for h in 0 .. ctxt.MaxHeight loop
			for w in 0 .. ctxt.MaxWidth loop
				if h = 0 or else h = ctxt.MaxHeight then
					Put("=");
				elsif w = 0 or else w = ctxt.MaxWidth then
					Put("|");
				else
					Put(" ");
				end if;
			end loop;
			New_Line;
		end loop;
		Put_Line("in Menu:");
		Put_Line("UP: z");
		Put_Line("DOWN: s");
		Put_Line("Selection: space");
		Put_Line("Back: r");
		GameContext.displayMenu;
		loop
			declare
				oldSelection: Natural := selection;
			begin
				Get_Immediate(c);
				case c is
				when 'z'=> selection := (if selection > 0 then selection - 1 else selection);
				when 's'=> selection := (if selection < 3 then selection + 1 else selection);
				when 'e'=> ctxt.Game.StopGame; -- TODO: add argument reason
					return;
				when ' '=>
					case selection is
					when 0 => GameContext.SetUpConfig(ctxt);
					when 1 => null; -- SetUpResum(ctxt);
					when 2 => null; -- SetUpLoadField(ctxt);
					when 3 => GameContext.SetUpGameInfo(ctxt); return;
					when others => null;
					end case;
				when others => null;
				end case;
				Print("-", SizeTerm(oldSelection + 2), 3);
				Print("o", SizeTerm(selection + 2), 3);
			end;
		end loop;
	end Menu;


	Ctxt: aliased GameContext.Context := init;

	task Keybording is
		entry Start;
	end Keybording;

	task body Keybording is begin
		null;
	end Keybording;
begin
   Menu(Ctxt);
end Main;
