package body Snake is

   	function NextPosFrom(dir: in Direction.Dir; pos: Position) return Position is
	begin
		case dir is
			when Up =>
				return (pos.X - 1, pos.Y)
			when Down =>
				return (pos.X + 1, pos.Y)
			when Left =>
				return (pos.X, pos.Y - 1)
			when Right =>
				return (pos.X, pos.Y + 1)
		end case;
		--CONTRAT MDR PANIC PAS OMG
   	end NexPosFrom;
	
   	function Creat(ctxt: in out GameContext.Context) return Snake is
	s : Snake;
	e: SnakeElem;
   	begin
		for i in 0 .. 4 loop
			e.pos := Position'(5, 3);
			e.color := None;
			e.zoom := ctxt.Config.Zoom;
			
			if i = 0 and ctxt.Config.Color then
				e.color := Blue;
			elif ctxt.Config.Color then
				e.color := Red;
			end if;
			s.elems.append(e);
		end loop;
		return (ctxt, s, Down)
   	end Creat;
	
   	procedure Display(s: in Snake) is
   	begin
		case s.zoom is
		when 1 =>
			MoveTo(s.pos.X, s.pos.Y + 1);
			if s.color /= None then
				SetColor(s.color);
			end if;
		end case;
   	end Display;
   
	procedure Hide(s: in Snake) is
   	begin
		case s.zoom is
		when 1 =>
			Print(" ", s.pos.X, s.pos.Y + 1);
		end case;
   	end Hide;
	
	procedure Move(s: in out Snake) is
   	begin
   	end Move;
   
	procedure Pos(s: in out Snake; p: Position) is
   	begin
		s.pos := p;
   	end Pos;
   
	function Pos(s: in Snake) return Position is
   	begin
		return s.pos;
   	end Pos;
   
	procedure ChangeDir(s: in out Snake; dir: in Direction.Dir) is
   	begin
   	end ChangeDir;
	
	procedure AddPoint(s: in out Snake) is
   	begin
   	end AddPoint;
   
	function Score(s: in out Snake) return Integer is
   	begin
   	end Score;
   
end Snake;
