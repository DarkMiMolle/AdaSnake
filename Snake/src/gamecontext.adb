with Ada.Text_IO; use Ada.Text_IO;

package body GameContext is

    procedure ClearMenu(ctxt: in Context) is

    begin -- ClearMenu
		  for x in 1 .. ctxt.maxHeight - 1 loop
              for y in 1 .. ctxt.MaxWidth - 1 loop
                  Print(" ", x, y);
              end loop;
          end loop;
    end ClearMenu;


    procedure displayMenu is

    begin -- displayMenu
        Print("o Configuration", 2, 3);
        Print("- Resum", 3, 3);
        Print("- Load field", 4, 3);
        Print("- Play", 5, 3);
    end displayMenu;

    procedure displayConfigPan(ctxt: in Context) is

    begin -- displayConfigPan
		 Print("o KeyMap", 2, 3);
         Print("- color off", 3, 3);
         Print("- zoom 1", 4, 3);
    end displayConfigPan;

    procedure SetUpKeymap(ctxt: in out Context) is
        selection: Key := Key'First;
        oldSelection: Key := selection;
        c: Character;
    begin -- SetUpKeymap
        loop
            oldSelection := selection;
            Get_Immediate(c);
            case c is
                when 'z' =>
                    if selection > Key'First then
                        selection := Key'Succ(selection);
                    end if;
                when 's' =>
                    if selection < Key'Last then
                        selection := Key'Pred(selection);
                    end if;
                when 'r' =>
                    ClearMenu(ctxt);
                    displayConfigPan(ctxt);
                    return;
                when ' ' =>
                    Print("* " & selection'Image & " : ", 2 + Key'Pos(selection), 3);
                    Get_Immediate(c);
                    Print("" & c);
					ctxt.conf.keymapping(selection) := c;
				when others =>
					null;
            end case;
            Print("-", 2 + Key'Pos(oldSelection), 3);
            Print("o", 2 + Key'Pos(selection), 3);
        end loop;
    end SetUpKeymap;


    -- Config
    procedure SetUpConfig(ctxt: in out Context) is
        selection: Natural := 0;
        oldSelection: Natural := selection;

        c: Character;
    begin -- SetUpConfig
        ClearMenu(ctxt);
        displayConfigPan(ctxt);
        loop
            oldSelection := selection;
            Get_Immediate(c);
            case c is
                when 'z' =>
                    if selection > 0 then
                        selection := selection - 1;
                    end if;
                when 's' =>
                    if selection < 2 then
                        selection := selection + 1;
                    end if;
            when 'r' =>
                ClearMenu(ctxt);
                displayMenu;
                return;
            when ' ' =>
                case selection is
                    when 0 =>
                        SetUpKeymap(ctxt);
                    when 1 =>
                        ctxt.conf.color := not ctxt.conf.color;
                        if ctxt.conf.color then
                            Print("on ", 3, 3 + 8); -- 8 for "- color ".len
                        else
                            Print("off", 3, 3 + 8);
                        end if;
                    when 2 =>
                        ctxt.conf.zoom := ctxt.conf.zoom mod 4;
                        ctxt.conf.zoom := ctxt.conf.zoom + 1;
						Print("" & ctxt.conf.zoom'Image, 4, 3 + 7); -- 7 for "- zoom ".len
					when others => null;
				end case;
			when others => null;
            end case;
            Print("-", SizeTerm(2 + oldSelection), 3);
            Print("o", SizeTerm(2 + selection), 3);
        end loop;
    end SetUpConfig;

	function Color(c: in Configuration) return Boolean is
	begin
		return c.color;
	end Color;

	function Zoom(c: in Configuration) return ZoomIndice is
    begin
        return c.zoom;
    end Zoom;

	function KeyMapped(c: in Configuration; k: Key) return Character is
    begin
        return c.keymapping(k);
    end KeyMapped;

	-- GameInfo
	procedure displayPlayPan is
	begin
        Print("o * Lv 1", 2, 3);
    	Print("-   Lv 2", 2 + 1, 3);
    	Print("-   Custom", 2 + 2, 3);
    	Print("- Confirm", 2 + 3, 3);
    	Print("path:", 2 + 4, 3);
	end displayPlayPan;


    procedure SetUpGameInfo (ctxt: in out Context) is
       selection: Natural := 0;
       prevSelection: Level := Level'Val(selection + 1);
       oldSelection: Natural := selection;
       loopContinue: Boolean := True;
       c: Character;
    begin
        ClearMenu(ctxt);
        displayPlayPan;
       loop
            exit when not loopContinue;
            oldSelection := selection;
            Get_Immediate(c);
            case c is
            when 'z' =>
                if selection > 0 then
                    selection := selection - 1;
                end if;
            when 's' =>
                if selection < 3 then
                   selection := selection + 1;
                end if;
            when ' ' =>
                if selection = 3 then
                   loopContinue := False;
                   ctxt.game.lv := prevSelection;
                else
                    -- May be remove the 2 +
                    Print("-  ", SizeTerm(2 + Level'Pos(prevSelection) - 1), 3);
                    prevSelection := Level'Val(selection + 1);
                    Print("o *", SizeTerm(2 + selection), 3);
                    if selection = 2 then
                        MoveTo(2 + 4, 3 + 6);-- "path: ".len == 6
         				ctxt.game.lvRef := Str.To_Unbounded_String(Get_Line);
         				MoveTo(2 + 2, 3);
                    end if;
				end if;
			when others => null;
            end case;
            Print("-", SizeTerm(2 + oldSelection), 3);
		    Print("o", SizeTerm(2 + selection), 3);
       end loop;
       ctxt.game.running := True;
       ctxt.game.pausing := False;
    end SetUpGameInfo;

    function Running(g: in GameInfo) return Boolean is
    begin
        return g.running;
    end Running;

	function Pausing(g: in GameInfo) return Boolean is
    begin
        return g.pausing;
    end Pausing;

	procedure StopGame(g: in out GameInfo) is
    begin
        g.running := false;
    end StopGame; -- TODO: add parametter reason


    -- Context
	function CreatContext(width, height: SizeTerm) return Context is
		ctxt: Context;
    begin
        ctxt.maxHeight := height;
    	ctxt.maxWidth := width;
    	ctxt.conf.color := false;
    	ctxt.conf.zoom := 1;
        return ctxt;
    end CreatContext;

	function MaxWidth(ctxt: in Context) return SizeTerm is
    begin
        return ctxt.maxWidth;
    end MaxWidth;

	function MaxHeight(ctxt: in Context) return SizeTerm is
    begin
        return ctxt.maxHeight;
    end MaxHeight;

	function Config(ctxt: in Context) return Configuration'Class is
    begin
        return ctxt.conf;
    end Config; -- to make the dispatching possible

	function Game(ctxt: in out Context) return access GameInfo'Class is
    begin
        return ctxt.game'Unchecked_Access;
    end Game;
end GameContext;
