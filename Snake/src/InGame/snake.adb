package body Snake is

   function NextPosFrom(dir: in Direction.Dir; pos: Position) return Position is
   begin
   end NexPosFrom;
	
	function Creat(ctxt: in out GameContext.Context) return Snake is
   begin
   end Creat;
	
	procedure Display(s: in Snake) is
   begin
   end Display;
   
	procedure Hide(s: in Snake) is
   begin
   end Hide;
	
	procedure Move(s: in out Snake) is
   begin
   end Move;
   
	procedure Pos(s: in out Snake; p: Position) is
   begin
   end Pos;
   
	function Pos(s: in Snake) return Position is
   begin
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
