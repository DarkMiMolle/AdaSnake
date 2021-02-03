with Snake; with Field;
with GameContext;
package InGame is

	package SnakePkg renames Snake;
	function CreatSnake(ctxt: in out GameContext.Context) return SnakePkg.Snake renames SnakePkg.Creat;

	subtype Snake is SnakePkg.Snake; -- "rename" Snake.Snake in InGame.Snake

	package Direction renames SnakePkg.Direction;

	package FieldPkg renames Field;
	function CreatField(ctxt: in out GameContext.Context) return FieldPkg.Field renames FieldPkg.CreatField;

	subtype Field is FieldPkg.Field;

end InGame;
