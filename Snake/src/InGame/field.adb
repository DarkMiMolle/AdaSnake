--with utility; use utility;

package body Field is
    function CreatField(ctxt: in out GameContext.Context) return Field is
    f2D : Field2D;
    begin
	-- raph: check les ranges mais normalement c'est ok
        for x in 0 .. ctxt.MaxWidth loop
            for y in 0 .. ctxt.MaxHeight loop
            	if y = 0 or y = ctxt.MaxHeight or x = 0 or x = ctxt.MaxWidth then
            	    f2D(x, y) := Wall;
            	else
            	    f2D(x, y) := Space;
            	end if;
            end loop;
        end loop;
	    return Field'(ctxt.MaxWidth, ctxt.MaxHeight, ctxt'Unchecked_Access, Position'(2, 2), Position'(10, 20), f2D);
    end CreatField;

    -- raph: ATTENTION, LES VALEURS SONT RANDOM, j'ai pas trouvé cette fonction dans le GO
    function Char(elem: FieldElem) return Character is
    begin
    	case elem is
    	    when Wall => return 'a';
    	    when Space => return 'b';
    	    when Empty => return 'c';
    	end case;
    end Char;

    -- raph: j'ai pas trouvé nextpoint dans les declaration, dans le doute je te laisse faire ^^
    function Check(f: in out Field; s: in out Snake.Snake) return Boolean is
    begin
        if f.representation(s.Pos.X, s.Pos.Y) = Wall then
		          f.ctxt.game.StopGame(GameContext.LostSnakeOnWall);
		return false;
	end if;

	if s.Pos.X = f.ptPos.X and s.Pos.Y = f.ptPos.Y then
		s.AddPoint;
		f.nextPoint; -- contrat: Post => f.ptPos n'est pas sur un mur ni en dehors du terrain
	end if;
	return true;

    end Check;

    -- raph: tu m'aideras
    procedure Paint(f: in Field) is
    x : PosTerm := 0;
    y : PosTerm := 0;
    begin
    	EraseConsole;
	for i in 0 .. f.width loop
		for j in 0 .. f.height loop
			x := i;
			y := j + 1;
			MoveTo(x, y);
			case f.representation(i, j) is
			    when Empty =>
				if f.ctxt.Config.Color then
					SetColor(Black);
				end if;
				Print("°");
			    when Wall =>
				if f.ctxt.Config.Color then
					SetColor(Brown);
				end if;
				Print("#");
			    when Space =>
			    	null;
			end case;
		end loop;
	end loop;
    end Paint;

    -- raph: pareil, pour ya des printfs
    procedure DisplayPt(f: in Field) is
    begin
    	MoveTo(f.ptPos.X, f.ptPos.Y + 1);
	if f.ctxt.Config.Color then
		SetColor(Green);
	end if;
	Print("+");
    end DisplayPt;
    
    procedure NextPt(f: in out Field) is
    	x : Integer := 0;
	y : Integer := 0;
    begin
    	loop
		x := rand.Int() % len(f.field);
		y := rand.Int() % len(f.field[x]);
		if f.field(x, y) = Space then
			f.ptPos.X = x;
			f.ptPos.Y = y;
			return;
		end if;
	end loop;
    end NextPt;

end Field;
