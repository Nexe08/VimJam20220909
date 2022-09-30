using Godot;
using System;

public class PacMan : RigidBody2D
{
    AnimationPlayer animPlayer;

    public override void _Ready()
    {
        animPlayer = FindNode("AnimationPlayer") as AnimationPlayer;
        animPlayer.Play("moving");
    }
    
}
