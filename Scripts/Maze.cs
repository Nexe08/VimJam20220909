using System.IO;
using Godot;
using System;

public class Maze : TileMap
{
    [Export] int width = 25; // width of the map (in tiles)
    [Export] int height = 25; // height of the map (in tiles)

    Vector2 tileSize;
    Godot.Collections.Dictionary<Vector2, int> cellWalls = new Godot.Collections.Dictionary<Vector2, int>();

    const int N = 1;
    const int E = 2;
    const int S = 4;
    const int W = 8;


    public override void _Ready()
    {
        GD.Randomize();
        tileSize = CellSize;

        cellWalls.Add(Vector2.Right, E);
        cellWalls.Add(Vector2.Left, W);
        cellWalls.Add(Vector2.Down, S);
        cellWalls.Add(Vector2.Up, N);
        MakeMaze();
    }

    async void MakeMaze()
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
        Vector2 current = new Vector2(0, 0);
        unvisited.Remove(current);

        // implimantation of algorithme
        while (unvisited.Count > 0)
        {
            Godot.Collections.Array neighbors = CheckNeighbors(current, unvisited);
            if (neighbors.Count > 0)
            {
                neighbors.Shuffle();
                Vector2 next = (Vector2) neighbors[0]; //(Vector2)neighbors[(int)GD.Randi() % (int)neighbors.Count];
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
                current = (Vector2) stack[stack.Count - 1];
                stack.RemoveAt(stack.Count - 1);
            }
                await ToSignal(GetTree(), "idle_frame");
        }
    }

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
}
