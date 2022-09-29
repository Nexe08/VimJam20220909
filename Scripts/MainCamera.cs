using System.Diagnostics;
using Godot;
using System;

public class MainCamera : Camera2D
{
    [Export] float rotationSpeed = 5f;
    
    public override void _Ready()
    {
        Current = true;
        Rotating = true;
        Vector2 screenSize = GetViewport().GetVisibleRect().Size;
        GlobalPosition = new Vector2(screenSize.x / 2, screenSize.y / 2);
    }


    public override void _Process(float delta)
    {
        if (Input.IsActionPressed("left"))
        {
            RotationDegrees = Mathf.Lerp(RotationDegrees, RotationDegrees + 10, rotationSpeed * delta);
        }
        else if (Input.IsActionPressed("right"))
        {
            RotationDegrees = Mathf.Lerp(RotationDegrees, RotationDegrees - 10, rotationSpeed * delta);
        }

        float gravityDirection = Mathf.Deg2Rad(RotationDegrees + 90);
        Physics2DServer.AreaSetParam(
            GetViewport().FindWorld2d().Space, 
            Physics2DServer.AreaParameter.GravityVector, 
            new Vector2(Mathf.Cos(gravityDirection), Mathf.Sin(gravityDirection))
        );
    }
}
