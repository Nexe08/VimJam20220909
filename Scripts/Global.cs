using Godot;
using System;

public class Global : Node
{
    public Node GameScene
    {
        get{return null;}
        set {GD.Print(GameScene , "  in global script");}
    }
}
