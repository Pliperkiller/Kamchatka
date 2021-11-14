using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrisslyPlayerData : MonoBehaviour
{

    public int health;
    public int level;
    public int points;
    public int honeyAmount;
    public bool nextLevel;
    public bool HasPuzzle;
    public bool Dead;
    public bool roundIsActive;
    

    void Start()
    {
        health = 100;
        level = 1;
        points = 0;
        honeyAmount = 0;
        nextLevel = false;
        HasPuzzle = false;
        Dead = false;
        roundIsActive = false;

    }

    // Update is called once per frame
    void Update()
    {

        if (health == 0)
        {
            Dead = true;
            Debug.Log(Dead);

            Destroy(GameObject.FindWithTag("Player"));
        }

        if (honeyAmount == 10)
        {
            nextLevel = true;

            Debug.Log(nextLevel);
        }
        
    }
}
