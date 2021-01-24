package body GameContext is

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