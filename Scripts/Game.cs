using Godot;
using System;

public class Game : Node2D
{
    Camera2D camera;
    Area2D firePlace;
    AudioStreamPlayer2D mazeRotationSFX;
    TileMap maze;
    ProgressBar fuleProgressBar;

    bool mazeCurrentlyRotating = false;


    public override void _Ready()
    {
        camera = GetNode<Camera2D>("MainCamera");
        firePlace = GetNode<Area2D>("FirePlace");
        mazeRotationSFX = GetNode<AudioStreamPlayer2D>("MovingMazeSFX");
        maze = GetNode<TileMap>("MapContainer/TileMap");
        fuleProgressBar = GetNode("%FuleProgressBar") as ProgressBar;
    }


    public override void _Process(float delta)
    {
        if (Input.IsActionPressed("left"))
        {
            if (mazeRotationSFX.Playing == false)
            {
                mazeRotationSFX.Play();
            }
            camera.RotationDegrees = Mathf.Lerp(camera.RotationDegrees, camera.RotationDegrees + 10, 5 * delta);
        }
        else if (Input.IsActionPressed("right"))
        {
            if (mazeRotationSFX.Playing == false)
            {
                mazeRotationSFX.Play();
            }
            camera.RotationDegrees = Mathf.Lerp(camera.RotationDegrees, camera.RotationDegrees - 10, 5 * delta);
        }
        else if (Input.IsActionJustPressed("Up"))
        {
            camera.RotationDegrees = camera.RotationDegrees - 90f;
        }
        else if (Input.IsActionJustPressed("Down"))
        {
            camera.RotationDegrees = camera.RotationDegrees + 90f;
        }

        if (Input.IsActionJustReleased("left"))
        {
            mazeRotationSFX.Stop();
        }
        else if (Input.IsActionJustReleased("right"))
        {
            mazeRotationSFX.Stop();
        }

        float camera_angle = Mathf.Deg2Rad(camera.RotationDegrees + 90);
        firePlace.RotationDegrees = camera.RotationDegrees;
        Physics2DServer.AreaSetParam(
            GetViewport().FindWorld2d().GetSpace(),
            Physics2DServer.AreaParameter.GravityVector,
            new Vector2(Mathf.Cos(camera_angle), Mathf.Sin(camera_angle))
        );
    }

    public void On_ResetButton_pressed()
    {
        
    }
}
