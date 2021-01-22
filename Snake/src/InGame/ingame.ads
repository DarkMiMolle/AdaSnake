package InGame is
	with Snake;

	package SnakePkg renames Snake;
	function CreatSnake return SnakePkg.Snake renames SnakePkg.Creat;
	
	subtype Snake is SnakePkg.Snake; -- "rename" Snake.Snake in InGame.Snake
   

end InGame;
