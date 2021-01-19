# AdaSnake
> The well known game *snake* on the (Unix) console with aditional features
---

## Features

- Menu
- Pause/Play
- Stop and Resume a Stoped game

### Menu
- Configuration
- Load your level
- Levels

#### Configuration
- Color (enable/disable)
- snake size (1 to 4)
- Controls (keymap)

#### Levels
2 levels (may be updated)
The classic one, and one with a labyrinth !

## Algo

```go

procedure main {
    var ctxt GameContext
    ctxt = Menu() // display the Menu and save the config
    if ctxt.resume then ResumGame(ctxt)
    else then RunGame(ctxt) 
}

procedure RunGame(ctxt in GameContext) {
    field := LoadField(ctxt)
    snake := CreatSnake(ctxt)
    pt := CreatPoint(ctxt)

    task(start) {
        wait start
        var input char
        while input != ctxt.keymap.exit {
            print_at(0, field.height + 1, "\r> ")
            get_immediat(&input)
            switch input {
                case ctxt.keymap.up: ChangeDir(&snake, UP)
                case ctxt.keymap.down: ChangeDir(&snake, Down)
                case ctxt.keymap.left: ChangeDir(&snake, Left)
                case ctxt.keymap.right: ChangeDir(&snake, Right)
                ...
            }
        }
    }
    while ctxt.game.runing {
        if !Check(&ctxt, &snake, &pt) {
            Lose(ctxt)
            break
        }
        Move(&snake, &field)
    }

}
```