package body GameContext is

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
                diplayMenu;
                return;
            when ' ' =>
                case selection is
                    when 0 =>
                        SetUpKeymap(ctxt);
                    when 1 =>
                        ctxt.conf.color := not ctxt.conf.color;
                        if ctxt.conf.color then
                            Print("on ", Position'(3, 3 + 8)); -- 8 for "- color ".len
                        else
                            Print("off", Position'(3, 3 + 8));
                        end if;
                    when 2 =>
                        ctxt.conf.zoom := ctxt.conf.zoom mod 4;
                        ctxt.conf.zoom := ctxt.conf.zoom + 1;
                        Print("" & ctxt.conf.zoom'Image, Position'(4, 3 + 7)); -- 7 for "- zoom ".len
                end case;
            end case;
            Print("-", Position'(2 + oldSelection, 3));
            Print("o", Position'(2 + selection, 3));
        end loop;
    end SetUpConfig;

    procedure SetUpGameInfo (ctxt: in out Context) is
       selection: Natural := 0;
       prevSelection: Natural := selection + 1;
       oldSelection: Natural := selection;
       loopContinue: Boolean := True;
       c: Charactere;
    begin
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
                    Print("-  ", Position'(2 + prevSelection - 1, 3));
                    prevSelection := selection + 1;
                    Print("o *", Position'(2 + selection, 3));
                    if selection = 2 then
                       null; --TODO
                    end if;
                end if;
            end case;
            Print("-", Position'(StartTerm + 2 + oldSelection, 3));
		    Print("o", Position'(StartTerm + 2 + selection, 3));
       end loop;
       ctxt.game.running := True;
       ctxt.game.pausing := False;
    end SetUpGameInfo;
end GameContext;
