using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerData : MonoBehaviour
{
    public int level;
    public int points;
    public bool HasPuzzle;
    public bool Dead;

    // Start is called before the first frame update
    void Start()
    {
        level = 1;
        points = 0;
        HasPuzzle = false;
        Dead = false;
    }
}
