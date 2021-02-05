# Snake ADA

---

> *The well known game "Snake" in ADA with a safe approach, on Console (Unix) with additional features*

---

## Build and run

Build with `gprbuild`:

`gprbuild -d -PSnake/snake.gpr Snake/src/main.adb`

Run:

`./Snake/obj/main`

---

## Features

- Set the size
- Menu 
  - Change the controls
  - Set color on/off
- Pause/Play

Controls in the menu are display and can't be changed.

---

## Algo

```go
var ctxt GameContext.Context = Initialisation // init the programme
var field InGame.Field = InGame.CreatField(&ctxt)
var snake InGame.Snake = InGame.CreatSnake(&ctxt)

task Keybording (Start) {
  var input char
  wait Start
  loop {
    get_immediat(&input)
    switch input {
      case ctxt.Config.Keymapped(Up): snake.ChangeDir(Up)
      case ctxt.Config.Keymapped(Down): snake.ChangeDir(Down)
      case ctxt.Config.Keymapped(Left): snake.ChangeDir(Left)
      case ctxt.Config.Keymapped(Right): snake.ChangeDir(Right)
      case ctxt.Config.Keymapped(Pause): ctxt.Game.Pause
	    case ctxt.Config.Keymapped(ExitGame): ctxt.Game.Stop(Stoped)
      case others: NOTHING
    }
  }
}

main {
  Menu(ctxt)
  field.Paint
  emit Keybording.Start
  loop {
    while ctxt.Game.Pausing {
      field.HidePt
      field.NextPt
    }
    break if !ctxt.Game.Running
    break if !field.Check(snake)
    field.DisplayPt
    snake.PrintScore
    snake.Move
    delay 0.15 second
  }
  ctxt.PrintEndGame
}

```

---

## Unimplemented additional features:

- Load your own field with a special file format
- Save the current state of your game to come back latter
- Multiple levels
- Different zoom
- Build your field
- Different snake speed

---

# Documentation of the Code

---

### Utility Pkg

**type** *PosTerm* & *SizeTerm*

> Used to navigate on the console
>
> **Constraint**: range 0 .. 100

**const** *StartTerm* : `PosTerm`

> use to make an offset too print on the console, to be sure we don't Print at 0, because it wouldn't be visible.

**type** *Position* : `record`

> public record that represent a position with coordinates x, y.
>
> _**x**_ : `PosTerm` - x coordinate.
>
> _**y**_ : `PosTerm` - y coordinate.

**type** *VectorPos* --> Vectors(Natural, Position).Vector

> A dynamic size array of `Position` from generic package Ada.Container.Vectors.

**type** *RandomPos* --> Discrete_Random(PosTerm).Generator

> A random generator of `Position` from generic package Ada.Numerics.Discrete_Random.

**type** *ColorName*

> enumeration of color for the console

**procedure** *Print_at*

> **args**: 
>
> - *str* : `String` - The things to print
> - *from* : `Position` - The position to print **or** *x, y* : `PosTerm` - The coordinates
>
> Print a message to the position/coordiate indicates. It interfaces a C function to handle the console navigation correctly.

**procedure** *Print*

> A call to Ada.Text_io.Put

**procedure** *MoveTo*

> **args**:
>
> - *x*, *y* : `PosTerm` - The coordinate to move the cursor at.
>
> Move the terminal cursor to the coordiante indicates. It interfaces a C function to handle the console navigation correctly.

**procedure** *SetColor*

> **args**:
>
> - *c* : `ColorName` - The color to set
>
> Set the color in the console. It interfaces a C function to handle the console correctly.

**procedure** *EraseConsole*

> Erase the console. It interfaces a C function to handle the console correctly.

## GameContext Pkg

**type** *Key*

> enumeration of the possible Key to interacte in the game.

**type** *KeyMap*

> Array of `Character` on `Key` range
>
> That type is use to binds a `Character` to each `Key`.

**type** *ZoomIndice* 

> Represent the zoom possible, from 1 to 3.
>
> **WARNING**: zoom management is not implemented in the game

**type** *Level*

> Represent the different level possible. LvCustom is supposed to be for letting the user give a file with a special format.
>
> **WARNING**: level management is not implemented in the game

**type** *GameStopedInfo*

> Represent the state of the game, and the reason of why the game is stoped if not Processing.

**procedure** *displayMenu*

> display the menu

**type** *Configuration*  `tagged record`

>Holds the configuration of the game
>
>(`in`) **function** *Color*
>
>> **return** `Boolean`
>>
>> Say if the color is set of not
>
>(`in`) **function** *Zoom*
>
>> **return** `ZoomIndice`
>>
>> Allows to know wich zoom is set
>>
>> **WARNING** zoom management is not implemented in the game
>
>(`in`) **function** *KeyMapped* 
>
>> **args**:
>>
>> *k* : `Key` 
>>
>> **return** `Character`
>>
>> Get the character that has been mapped to the key "k".

**procedure** *SetUpConfig*

> **args**:
>
> *ctxt* : `in out Context` - The context that owns the config to set up
>
> Set up the configuration. Display a configuration panel for the user to change as he wants.

**type** *GameInfo* `tagged record`

> Holds information about the game, and allows to interact with it.
>
> (`in`) **function** *Running* 
>
> > **return** `Boolean`
> >
> > Say if the game is running or not.
>
> (`in`) **function** *Pausing* 
>
> > **return** `Boolean`
> > **Pre** => `.Running`
> >
> > Say if the game is in pause or not.
>
> (`in out`) **procedure** *StopGame*
>
> > **args**: 
> >
> > *reason* : `GameStopedInfo` - Why do we stop the game.
> >
> > **Pre** => `.Running`
> >
> > **Post** => `not .Running`
> >
> > Stop the game through different reasons.
>
> (`in out`) **procedure** *Pause*
>
> > **Pre** => `.Running`
> >
> > **Post** => `.Running and not .Pausing`
> >
> > Pause the game

**procedure** *SetUpGameInfo*

> **args**:
>
> *ctxt* : `in out Context` - The context that owns the GameInfo to set up
>
> Set up the Game's information right befor lunching the game. Display a configuration panel for the user to select the level he wants.
>
> **WARNING**: level management is not implemented in the game

?	**type** *Context* `tagged record`

> (`in`) **function** *MaxWidth*
>
> > **return** `SizeTerm`
> >
> > Give the max width to display on the console, specify by the user.
>
> (`in`) **function** *MaxHeight*
>
> > **return** `SizeTerm`
> >
> > Give the max height to display on the console, specify by the user.
>
> (`in`) **function** *Config*
>
> > **return** `Configuration'Class` - 'Class to make the dispatching possible
> >
> > Give the configuration settings.
>
> (`in out`) **function** *Game* 
>
> > **return** `access GameInfo'Class` - The game information may change durring the game.
> > **Post** => `.Game /= null`
>
> (`in`) **procedure** *EndGame* 
>
> > **args**:
> >
> > *score* : `Integer` - The score at the end of the game
> > **Pre** => `not .Game.Running`
> >
> > Display the end of the game with the score and the reason of the lost.

**function** *CreatContext* 

> **args**:
>
> *width*, *height* : `SizeTerm` - the dimention of the max size to set for the context
>
> **return** `Context`
> **Post** => `CreatContext'Result.Game.Running`

##InGame Pkg: Field Pkg and Snake Pkg

**package.type** *Direction.Dir*

> A constraint integer from -2 to 2 `with` a value `/= 0`.
>
> **const** Up = -1
>
> **const** Down = 1
>
> **const** Left = -2
>
> **const** Right = 2
>
> The logic is that it is not possible to make `Up + Down` nor `Left + Right` as 0 isn't a value; And in the snake it is not possible to switch from on direction to its opposite.

**function** *NextPosFrom*

> **args**:
>
> *dir* :  `in Direction.Dir`
>
> *pos* : `Position`
>
> **return** `Position`
>
> **Post**  `pos /= NextPosFrom'Result`
>
> Gives the next position regarding a direction.

**type** *Snake* `tagged record`

>It represent the snake.
>
>TODO
>
>function Creat(ctxt: in out GameContext.Context) return Snake
>		with 	Pre => ctxt.Game.Running and ctxt'Unchecked_Access /= null;
>
>?	procedure Display(s: in Snake)
>?		with 	Pre => s.G_GameRunning;
>
>?	procedure Move(s: in out Snake)
>?		with 	Pre => s.G_GameRunning,
>?				Post => s.Pos'Old /= s.Pos and s.Pos = NextPosFrom(s.G_Dir, s.Pos);
>?	procedure Pos(s: in out Snake; p: Position)
>?		with 	Post => s.Pos = p;
>?	function Pos(s: in Snake) return Position;
>?	procedure ChangeDir(s: in out Snake; dir: in Direction.Dir)
>?		with 	Post => Integer(s.G_Dir) = Integer(dir);
>
>?	procedure AddPoint(s: in out Snake)
>?		with 	Post => s.G_GameRunning and s.Score = s'Old.G_Score + 1;
>?	function Score(s: in out Snake) return Integer;

**type** *FieldElem*

> Enumeration used to represent the kind of the field.

**function** *Char*

> **args**:
>
> *elem* : `in FieldElem`
>
> **return** `Character`
>
> To get the represented character of the elem.

**type** Field `tagged record`

> (`in out`) **function** *Check*
>
> > **args**:
> >
> > *s* : `in out Snake.Snake`
> >
> > **return** `Boolean`
> >
> > **Pre** `.GameRunning` - the game must be running
> >
> > **Post** `.Ghost.GameRunning = (.Ghost.FieldElemAt(s.Pos) = Space)
> > 			and ((.Ghost.GameRunning and then (.Ghost.FieldElemAt(f.G_PtPos) = Space and .Ghost.PtPos /= s.Pos)) or else not .Ghost.GameRunning)` - FieldElemAt gives the FieldElem at the given pos, and PtPos gives the position of the point.
> >
> > Check if the game can continue or if it must stope.
>
> (`in`) **procedure** *Paint*
>
> > **Pre** `.Ghost.GameRunning`
> >
> > Paint the field without the point.
>
> (`in`) **procedure** *DisplayPt*
>
> > **Pre** `.Ghost.GameRunning`
> >
> > Display the point
>
> (`in out`) **procedure** *NextPoint*
>
> > **Pre** `.Ghost.GameRunning and (.Ghost.SnakePos = .Ghost.PtPos or (.Ghost.Context /= null and then .Ghost.Context.Game.Pausing))` - Context return the context of the current game, SnakePos return the current pos of the snake
> >
> > **Post** .Ghost.PtPos'Old /= .Ghost.PtPos and .Ghost.FieldElemAt(.Ghost.PtPos) = Space and .Ghost.PtPos /= .Ghost.SnakePos;
> >
> > Set the next point on the field and ensure it is not at the place and inside the field.
>
> (`in`)	**procedure** *HidePt*
>
> > **Pre** .Ghost.GamePausing
> >
> > Hide the point if we are in pause.

