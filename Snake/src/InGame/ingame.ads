with Snake;
with GameContexts;
package InGame is

	package SnakePkg renames Snake;
	function CreatSnake(ctxt: in out GameContexts.Context) return SnakePkg.Snake renames SnakePkg.Creat;
	
	subtype Snake is SnakePkg.Snake; -- "rename" Snake.Snake in InGame.Snake
   
	

end InGame;
