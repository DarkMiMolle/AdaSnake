--with Ada.Text_IO; use Ada.Text_IO;
package body Snake is

    function SnakeColorAt(i: Integer; isColored: Boolean) return ColorName is
    begin
        return (if isColored then (if i = 0 then Blue else Red) else None);
    end SnakeColorAt;

   	function NextPosFrom(dir: in Direction.Dir; pos: Position) return Position is
	begin
		case dir is
			when Direction.Up =>
				return (pos.X - 1, pos.Y);
			when Direction.Down =>
				return (pos.X + 1, pos.Y);
			when Direction.Left =>
				return (pos.X, pos.Y - 1);
			when Direction.Right =>
				return (pos.X, pos.Y + 1);
            -- when others => null; -- case 0 unpossible with contrat
		end case;
   	end NextPosFrom;

   	function Creat(ctxt: in out GameContext.Context) return Snake is
		s : Snake;
   	begin
		for i in 0 .. 4 loop
			s.elems.append(SnakeElem'(pos => Position'(5, 3)));
		end loop;
		s.ctxt := ctxt'Unchecked_Access;
		s.dir := Direction.Down;
		return s;
   	end Creat;

   	procedure Display(s: in Snake) is
   	begin
		for p in 0 .. s.elems.Length loop
            declare
                i: Integer := Integer(p);
            begin
			    s.elems.Element(i).Display(s.ctxt.Config.Zoom, SnakeColorAt(i, s.ctxt.Config.Color));
            end;
        end loop;
   	end Display;

	procedure Display(elem: in SnakeElem; zm: GameContext.ZoomIndice; cl: ColorName)
    is
   	begin
		case zm is
    		when 1 =>
    			MoveTo(elem.pos.x, elem.pos.y);
    			if cl /= None then
    				SetColor(cl);
    			end if;
                Print("*");
            when others => null;
		end case;
   	end Display;

	procedure Hide(s: in SnakeElem; zm: GameContext.ZoomIndice) is
   	begin
		case zm is
		when 1 =>
			Print_at(" ", s.pos.X, s.pos.Y);
        when others => null;
		end case;
   	end Hide;

	procedure Move(s: in out Snake) is
		head : SnakeElem;
        elem : SnakeElem;
   	begin
		head := s.elems.First_Element;
		Pos(head, NextPosFrom(s.dir, head.pos));
		Hide(s.elems.Last_Element, s.ctxt.Config.Zoom);

		for p in reverse 1 .. s.elems.Length - 1 loop
            declare
                i: Integer := Integer(p);
            begin
                elem := s.elems.Element(i);
    			elem.pos.X := s.elems.Element(i - 1).pos.X;
    			elem.pos.Y := s.elems.Element(i - 1).pos.Y;
                s.elems.Replace_Element(i, elem);
    			s.elems.Element(i).Display(s.ctxt.Config.Zoom, SnakeColorAt(i, s.ctxt.Config.Color));
    			if s.elems.Element(i).pos.X = head.pos.X and s.elems.Element(i).pos.Y = head.pos.Y then
    				s.ctxt.Game.StopGame(GameContext.LostSnakeEatItself);
    			end if;
            end;

		end loop;
		s.elems.Replace_Element(0, head);
		s.elems.Element(0).Display(s.ctxt.Config.Zoom, SnakeColorAt(0, s.ctxt.Config.Color));
   	end Move;

	procedure Pos(s: in out Snake; p: Position) is
        newElem: SnakeElem := (pos => p);
   	begin
		s.elems.Replace_Element(0, newElem);
   	end Pos;

	function Pos(s: in Snake) return Position is
   	begin
		return s.elems.First_Element.pos;
   	end Pos;

	procedure Pos(elem: in out SnakeElem; p: Position) is
	begin
		elem.pos := p;
	end Pos;

	function Pos(elem: in SnakeElem) return Position is
   	begin
		return elem.pos;
   	end Pos;

	procedure ChangeDir(s: in out Snake; dir: in Direction.Dir) is
		p : Position;
   	begin
		-- UP + DOWN == 0 (-1 + 1) && LEFT + RIGHT == 0 (-2 + 2)
		if Integer(dir) + Integer(s.dir) /= 0 then
			p := NextPosFrom(dir, Pos(s));
			if s.elems.Element(1).pos.X = p.X and s.elems.Element(1).pos.Y = p.Y then
				return;
			end if;
			s.dir := dir;
		end if;
   	end ChangeDir;

	procedure AddPoint(s: in out Snake) is
   	begin
		s.elems.append(s.elems.Last_Element);
   	end AddPoint;

	function Score(s: in out Snake) return Integer is
   	begin
		return Integer(s.elems.Length);
   	end Score;

    function G_GameRunning(s: in Snake) return Boolean is
    begin
        return s.ctxt.Game.Running;
    end G_GameRunning;
	function G_Dir(s: in Snake) return Direction.Dir is
    begin
        return s.dir;
    end G_Dir;
    function G_Score(s: Snake) return Integer is
    begin
        return Integer(s.elems.Length);
    end G_Score;
end Snake;
