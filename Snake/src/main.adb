with GameContext;
with Ada.Text_IO; use Ada.Text_IO;
with Utility; use Utility;

procedure Main is
	function init return GameContext.Context is
		w, h: Utility.SizeTerm;
	begin
		Put("Max width of the term: ");
		w := Integer'Value(Get_Line);
		Put("Max Height of the term: ");
		h := Integer'Value(Get_Line);
		return GameContext.CreatContext(w, h);
	end init;

	procedure display_menu is
	begin
		Print("o Configuration", Position'(StartTerm + 2, 3));
		Print("- Resum", Position'(StartTerm + 3, 3));
		Print("- Load Field", Position'(StartTerm + 4, 3));
		Print("- Play", Position'(StartTerm + 5, 3));
	end display_menu;

	procedure Menu(ctxt: in out GameContext.Context) is
		c: Character;
		selection: Natural := 0;
	begin
		MoveTo(StartTerm, 0);
		for h in 1 .. ctxt.MaxHeight loop
			for w in 1 .. ctxt.MaxWidth loop
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
		display_menu;
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
					end case;
				end case;
				Print("-", Position'(StartTerm + 2 + oldSelection, 3));
				Print("o", Position'(StartTerm + 2 + selection, 3));
			end;
		end loop;
	end Menu;

	Ctxt: aliased GameContext.Context := init;

	task Keybording is
		entry Start;
	end Keybording;

	task body Keybording is
		c: Character;
	begin
		accept Start;
		loop
			exit when not ctxt.Game.Running;
			Get_Immediate(c);
		end loop;
	end Keybording;
begin
   --  Insert code here.
   null;
end Main;
