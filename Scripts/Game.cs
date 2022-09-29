using Godot;
using System;

public class Game : Node2D
{
    public override void _Ready()
    {
        GD.Print(GetNode(".").Name);
        GetNode<Global>("/root/Global").GameScene = GetNode(".");
        
    }
}
