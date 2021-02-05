--with utility; use utility;
package body Field is

    function G_CheckRepresentation(f: Field) return Boolean is
    begin
        for x in f.representation'range(1) loop
            for y in f.representation'range(2) loop
                if x > f.width and y > f.height then
                    if f.representation(x, y) /= Empty then
                        return False;
                    end if;
                end if;
            end loop;
        end loop;
        return True and f.representation(f.ptPos.x, f.ptPos.y) = Space;
    end G_CheckRepresentation;

    function CreatField(ctxt: in out GameContext.Context) return Field is
        f2D : Field2D;
        pt: Position := (0, 0);
    begin
	       -- raph: check les ranges mais normalement c'est ok
        for x in Field2D'range(1) loop
            for y in Field2D'range(2) loop
                if x <= ctxt.MaxHeight and y <= ctxt.MaxWidth then
                	if x = 0 or x = ctxt.MaxHeight or y = 0 or y = ctxt.MaxWidth then
                	    f2D(x, y) := Wall;
                	else
                	    f2D(x, y) := Space;
                        if pt.x = 0 and pt.y = 0 then pt := Position'(x, y); end if;
                	end if;
                else
                    f2D(x, y) := Empty;
                end if;
            end loop;
        end loop;
	    return Field'(ctxt.MaxWidth, ctxt.MaxHeight, ctxt'Unchecked_Access, Position'(2, 2), pt, f2D);
    end CreatField;

    -- raph: ATTENTION, LES VALEURS SONT RANDOM, j'ai pas trouvé cette fonction dans le GO
    function Char(elem: FieldElem) return Character is
    begin
    	case elem is
    	    when Wall => return '#';
    	    when Space => return ' ';
    	    when Empty => return ''';
    	end case;
    end Char;

    function G_Context(f: in Field) return access GameContext.Context is
    begin
        return f.ctxt;
    end;
    function G_GameRunning(f: in Field) return Boolean is
    begin
        return f.ctxt.Game.Running;
    end;
    function G_GamePausing(f: in Field) return Boolean is
    begin
        return f.ctxt.Game.Pausing;
    end;
    function G_SnakePos(f: in Field) return Position is
    begin
        return f.snakePos;
    end G_SnakePos;
	function G_PtPos(f: in Field) return Position is
    begin
        return f.ptPos;
    end G_PtPos;
    function G_FieldElemAt(f: Field; pos: Position) return FieldElem is
    begin -- G_FieldElemAt
        return f.representation(pos.X, pos.Y);
    end G_FieldElemAt;
    -- raph: j'ai pas trouvé nextpoint dans les declaration, dans le doute je te laisse faire ^^
    function Check(f: in out Field; s: in out Snake.Snake) return Boolean is
    begin
        f.snakePos := s.Pos;
        if f.representation(s.Pos.X, s.Pos.Y) = Wall then
		    f.ctxt.game.StopGame(GameContext.LostSnakeOnWall);
			return false;
		end if;

    	if s.Pos.X = f.ptPos.X and s.Pos.Y = f.ptPos.Y then
    		s.AddPoint;
            f.nextPoint; -- we know it won't be placed in the same place the previous point and it won't be on the snake pos, thanks contract.
    	end if;
    	return true;

    end Check;

    -- raph: tu m'aideras
    procedure Paint(f: in Field) is
        x : PosTerm := 0;
        y : PosTerm := 0;
    begin
    	EraseConsole;
	    for x in 0 .. f.height loop
    		for y in 0 .. f.width loop
    			MoveTo(x, y);
    			case f.representation(x, y) is
    			    when Empty =>
    				if f.ctxt.Config.Color then
    					SetColor(Black);
    				end if;
    			    when Wall =>
    				if f.ctxt.Config.Color then
    					SetColor(Brown);
    				end if;
    			    when Space =>
    			    	null;
    			end case;
                Print("" & Char(f.representation(x, y)));
    		end loop;
        end loop;
    end Paint;

    -- raph: pareil, pour ya des printfs
    procedure DisplayPt(f: in Field) is
    begin
    	MoveTo(f.ptPos.X, f.ptPos.Y);
    	if f.ctxt.Config.Color then
    		SetColor(Green);
    	end if;
	       Print("+");
    end DisplayPt;

    procedure HidePt(f: in Field) is
    begin
        Print_at(" ", f.ptPos.x, f.ptPos.y);
    end;

    procedure NextPoint(f: in out Field) is
    	x : PosTerm := 0;
        y : PosTerm := 0;
        seed: RandomPos;
    begin
        RandomPosPkg.Reset(seed);
    	loop
    		x := RandomPosPkg.Random(seed);
    		y := RandomPosPkg.Random(seed);
    		if x < f.width and then y < f.height and then f.representation(x, y) = Space then
    			f.ptPos.X := x;
    			f.ptPos.Y := y;
    			return;
    		end if;
	   end loop;
    end NextPoint;

end Field;
