--with utility; use utility;

package body Field is
    function CreatField(ctxt: in out GameContext.Context) return Field is
    f2D : Field2D(ctxt.maxWidth, ctxt.maxHeight);
    begin
	-- raph: check les ranges mais normalement c'est ok
        for x in 0 .. ctxt.maxWidth loop
    	    for y in 0 .. ctxt.maxHeight loop
        		if y = 0 or y = ctxt.maxHeight or x = 0 or ctxt.maxWidth then
        		    f2D(x, y) = Wall;
        		else
        		    f2D(x, y) = Space;
        		end if;
    	    end loop;
        end loop;
	return (ctxt, (StartTerm + 2, 2), (StartTerm + 10, 20), f2D);
    end CreatField;

    -- raph: ATTENTION, LES VALEURS SONT RANDOM, j'ai pas trouvé cette fonction dans le GO
    function Char(elem: FieldElem) return Character is
    begin
	case elem is
	    when Wall =>
		      return 'a';
	    when Space =>
		      return 'b';
	    when Empty =>
		      return 'c';
    end Char;

    -- raph: j'ai pas trouvé nextpoint dans les declaration, dans le doute je te laisse faire ^^
    function Check(f: in out Field; s: in out Snake.Snake) return Boolean is
    begin
        if f.representation(s.Pos().X, s.Pos().Y) = Wall then
		--f.ctxt.game.Stop(GameContext.LostSnakeOnWall)
                GameContext.StopGame(GameContext.LostSnakeOnWall);
		return false;
	end if;

	if s.elems.X = f.ptPos.X and s.elems.Y = f.ptPos.Y then
		s.AddPoint(s);
		f.nextPoint(); -- contrat: Post => f.ptPos n'est pas sur un mur ni en dehors du terrain
	end if;
	return true;

    end Check;

    -- raph: tu m'aideras
    procedure Paint(f: in Field);

    -- raph: pareil, pour ya des printfs
    procedure DisplayPt(f: in Field);

end Field;
