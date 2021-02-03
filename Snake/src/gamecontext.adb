with Ada.Text_IO; use Ada.Text_IO;

package body GameContext is

    procedure ClearMenu(ctxt: in Context) is
    begin
        for x in 2 .. ctxt.maxHeight - 2 loop
          for y in 2 .. ctxt.MaxWidth - 2 loop
              Print_at(" ", x, y);
          end loop;
        end loop;
    end ClearMenu;


    procedure displayMenu is
    begin -- displayMenu
        Print_at("o Configuration", 2, 3);
        Print_at("- Resum", 3, 3);
        Print_at("- Load field", 4, 3);
        Print_at("- Play", 5, 3);
    end displayMenu;

    procedure displayConfigPan(ctxt: in Context) is
        color: String := (if ctxt.conf.color then "on" else "off");
    begin -- displayConfigPan
        Print_at("o KeyMap", 2, 3);
        Print_at("- color " & color, 3, 3);
        Print_at("- zoom " & ctxt.conf.zoom'Image, 4, 3);
    end displayConfigPan;

    procedure SetUpKeymap(ctxt: in out Context) is
        selection: Key := Key'First;
        oldSelection: Key := selection;
        c: Character;
    begin -- SetUpKeymap
        ClearMenu(ctxt);
        for k in ctxt.conf.keymapping'range loop
            Print_at("- " & k'Image & " : " & ctxt.conf.keymapping(k), 2 + SizeTerm(Key'Pos(k)), 3);
        end loop;
        loop
            Print_at("o", 2 + Key'Pos(selection), 3);
            oldSelection := selection;
            Get_Immediate(c);
            case c is
                when 'z' =>
                    if selection > Key'First then
                        selection := Key'Pred(selection);
                    end if;
                when 's' =>
                    if selection < Key'Last then
                        selection := Key'Succ(selection);
                    end if;
                when 'r' =>
                    ClearMenu(ctxt);
                    displayConfigPan(ctxt);
                    return;
                when ' ' =>
                    Print_at("* " & selection'Image & " : ", 2 + Key'Pos(selection), 3);
                    MoveTo(SizeTerm(2 + Key'Pos(selection)), SizeTerm(3 + 2 + selection'Image'Last - selection'Image'First + 4));
                    Get_Immediate(c);
					ctxt.conf.keymapping(selection) := c;
                    Print("" & ctxt.conf.keymapping(selection));
				when others =>
					null;
            end case;
            Print_at("-", 2 + Key'Pos(oldSelection), 3);
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
                            Print_at("on ", 3, 3 + 8); -- 8 for "- color ".len
                        else
                            Print_at("off", 3, 3 + 8);
                        end if;
                    when 2 =>
                        if ctxt.conf.zoom = ZoomIndice'Last then
                            ctxt.conf.zoom := ZoomIndice'First;
                        else
                            ctxt.conf.zoom := ctxt.conf.zoom + 1;
                        end if;
						Print_at(ctxt.conf.zoom'Image, 4, 3 + 7); -- 7 for "- zoom ".len
					when others => null;
				end case;
			when others => null;
            end case;
            Print_at("-", PosTerm(2 + oldSelection), 3);
            Print_at("o", PosTerm(2 + selection), 3);
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
        Print_at("o * Lv 1", 2, 3);
    	Print_at("-   Lv 2", 2 + 1, 3);
    	Print_at("-   Custom", 2 + 2, 3);
    	Print_at("- Confirm", 2 + 3, 3);
    	Print_at("path:", 2 + 4, 3);
	end displayPlayPan;


    procedure SetUpGameInfo (ctxt: in out Context) is
       selection: Natural := 0;
       prevSelection: Level := Level'Val(selection);
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
                    -- 2 + --> offset from the top of the menu
                    Print_at("-  ", PosTerm(2 + Level'Pos(prevSelection)), 3);
                    prevSelection := Level'Val(selection);
                    Print_at("o *", PosTerm(2 + selection), 3);
                    if selection = 2 then
                        MoveTo(2 + 4, 3 + 6);-- "path: ".len == 6
         				ctxt.game.lvRef := Str.To_Unbounded_String(Get_Line);
         				MoveTo(2 + 2, 3);
                    end if;
				end if;
			when others => null;
            end case;
            Print_at("-", PosTerm(2 + oldSelection), 3);
		    Print_at("o", PosTerm(2 + selection), 3);
       end loop;
       ctxt.game.running := Processing;
       ctxt.game.pausing := False;
    end SetUpGameInfo;

    function Running(g: in GameInfo) return Boolean is
    begin
        return g.running = Processing;
    end Running;

	function Pausing(g: in GameInfo) return Boolean is
    begin
        return g.pausing;
    end Pausing;

	procedure StopGame(g: in out GameInfo; reason: GameStopedInfo) is
    begin
        g.running := reason;
    end StopGame; -- TODO: add parametter reason

    procedure Pause(g: in out GameInfo) is
    begin -- Pause
        g.pausing := True;
    end Pause;

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
