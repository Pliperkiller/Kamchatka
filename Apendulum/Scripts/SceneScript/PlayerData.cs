using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerData : MonoBehaviour
{
    public int points;
    public bool HasPuzzle;
    public bool puzzleOnBoard;
    public bool Dead;


    // Start is called before the first frame update
    void Start()
    {
        points = 0;
        HasPuzzle = false;
        puzzleOnBoard = false;
        Dead = false;
    }
}
