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
   	begin
		for i in 0 .. 4 loop
			s.elems.append(Position'(5, 3));
		end loop;
		s.ctxt := ctxt;
		s.dir := Down;
		return s;
   	end Creat;
	
   	procedure Display(s: in Snake) is
   	begin
		for i in 0 .. s.elems.Length loop
			Display(s.elems.Element(i), s.ctxt.Config.Zoom, s.ctxt.Config.Color);
		end loop;
   	end Display;
	
	procedure Display(elem: in SnakeElem; zm: GameContext.ZoomIndice; cl: ColorName) is
   	begin
		case zm is
		when 1 =>
			MoveTo(elem.X, elem.Y + 1);
			if cl /= None then
				SetColor(cl);
			end if;
		end case;
   	end Display;
	
	procedure Hide(elem: in SnakeElem; zm: GameContext.ZoomIndice) is
   	begin
		case zm is
		when 1 =>
			Print_at(" ", s.pos.X, s.pos.Y + 1);
		end case;
   	end Hide;
	
	procedure Move(s: in out Snake) is
	head : SnakeElem;
   	begin
		head := s.elems.First_Element;
		head.Pos := 
		
   	end Move;
   
	procedure Pos(s: in out Snake; p: Position) is
   	begin
		s.elems.First_Element.pos := p;
   	end Pos;
   
	function Pos(s: in Snake) return Position is
   	begin
		return s.elems.First_Element.pos;
   	end Pos;
	
	function Pos(elem: in SnakeElem) return Position is
   	begin
		return elem.pos;
   	end Pos;
   
	procedure ChangeDir(s: in out Snake; dir: in Direction.Dir) is
	p : Position;
   	begin
		-- UP + DOWN == 0 (-1 + 1) && LEFT + RIGHT == 0 (-2 + 2)
		if dir + s.dir /= 0 then
			p := NextPosFrom(dir, Pos(s));
			if s.elems.Element(1).pos.X = p.X and s.elems.Element(1).pos.Y = p.Y then
				return;
			end if;
			s.dir = dir;
		end if;
   	end ChangeDir;
	
	procedure AddPoint(s: in out Snake) is
   	begin
		s.elems.append(s.elems.Last_Element);
   	end AddPoint;
   
	function Score(s: in out Snake) return Integer is
   	begin
		return s.elems.Length;
   	end Score;
   
end Snake;
