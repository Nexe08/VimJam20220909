using System.IO;
using Godot;
using System;

public class Maze : TileMap
{
    // Export var

    [Export] int width = 25; // width of the map (in tiles)
    [Export] int height = 25; // height of the map (in tiles)


    // Defined Private var

    Godot.Collections.Dictionary<Vector2, int> cellWalls = new Godot.Collections.Dictionary<Vector2, int>();

    // Undefined private var

    Vector2 tileSize;
    Vector2 ScreenSize; // Stores size vector of screen size


    // Constants

    const int N = 1;
    const int E = 2;
    const int S = 4;
    const int W = 8;


    // Packed Scene Paths

    PackedScene pacManResPath = ResourceLoader.Load("res://Prefabes/PacMan.tscn") as PackedScene;



    public override void _Ready()
    {
        ScreenSize = GetViewport().GetVisibleRect().Size;
        GD.Randomize();
        tileSize = CellSize;

        cellWalls.Add(Vector2.Right, E);
        cellWalls.Add(Vector2.Left, W);
        cellWalls.Add(Vector2.Down, S);
        cellWalls.Add(Vector2.Up, N);

        // Place it in the center of screen based on its size and screen size
        GlobalPosition = new Vector2(
            ScreenSize.x / 2 - ((width * tileSize.x) / 2),
            ScreenSize.y / 2 - ((height * tileSize.y) / 2)
        );

        MakeMaze();
    }

    /*
    This uses BackTracking Methode to generate maze.
    This function include:
    - Maze generation Methode
    - Calling "CheckNeighbore" Function
    - Calling "SpawnPacManInstance" Function
    */

    void MakeMaze()
    {
        Godot.Collections.Array unvisited = new Godot.Collections.Array();
        Godot.Collections.Array stack = new Godot.Collections.Array();

        // fill the map with solid color
        Clear();
        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                unvisited.Add(new Vector2(x, y));
                SetCellv(new Vector2(x, y), N | E | S | W);
            }
        }
        Vector2 current = new Vector2(0, 0); // Vector2(GlobalPosition.x, GlobalPosition.y + (height * tileSize.y) / 2);
        Vector2 startPosition = MapToWorld(current);
        unvisited.Remove(current);

        // implimantation of algorithme
        while (unvisited.Count > 0)
        {
            Godot.Collections.Array neighbors = CheckNeighbors(current, unvisited);
            if (neighbors.Count > 0)
            {
                neighbors.Shuffle();
                Vector2 next = (Vector2)neighbors[0]; //(Vector2)neighbors[(int)GD.Randi() % (int)neighbors.Count];
                stack.Add(current);
                //remove walls from both cells
                Vector2 dir = next - current;
                int currentWalls = GetCellv(current) - cellWalls[dir];
                int nextWalls = GetCellv(next) - cellWalls[-dir];
                SetCellv(current, currentWalls);
                SetCellv(next, nextWalls);
                current = next;
                unvisited.Remove(current);
            }
            else if (stack.Count > 0)
            {
                current = (Vector2)stack[stack.Count - 1];
                stack.RemoveAt(stack.Count - 1);
            }
            // await ToSignal(GetTree(), "idle_frame");
        }

        SpawnPacManInstance(startPosition);
    }

    /*
    Return's the list of neighbors which are not visited yet.
    */

    Godot.Collections.Array CheckNeighbors(Vector2 _cell, Godot.Collections.Array _unvisited)
    {
        Godot.Collections.Array list = new Godot.Collections.Array();
        foreach (Vector2 n in cellWalls.Keys)
        {
            if (_unvisited.Contains(_cell + n))
            {
                list.Add(_cell + n);
            }
        }
        return list;
    }

    /*
    Spawn Packman after maze generation is finished
    This function is called in MakeMaze() function
    [param]: _spawn_positon "Position where Pac Man instance is going to spawn"
    */

    void SpawnPacManInstance(Vector2 _spawn_position)
    {
        var instance = pacManResPath.Instance() as RigidBody2D;

        instance.GlobalPosition = ToGlobal(_spawn_position) + (tileSize / 2);
        // instance.GlobalPosition = WorldToMap(_spawn_position);
        // GetParent().AddChild(instance);
        GetParent().CallDeferred("add_child", instance);
    }
}
