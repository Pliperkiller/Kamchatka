using UnityEngine;

public class GrisslyPlayerData : MonoBehaviour
{

    public int health;
    public int level;
    public int points;
    public int honeyAmount;
    public int ammo;
    public bool nextLevel;
    public bool HasPuzzle;
    public bool Dead;
    public bool roundIsActive;
    public bool onCamp;
    
    

    void Start()
    {
        health = 100;
        level = 1;
        points = 0;
        honeyAmount = 0;
        ammo = 100;
        nextLevel = false;
        HasPuzzle = false;
        Dead = false;
        roundIsActive = false;
        onCamp = false;


    }

    // Update is called once per frame
    void Update()
    {

        if (health == 0)
        {
            Dead = true;
            Debug.Log(Dead);

        }

        if (honeyAmount == 10)
        {
            nextLevel = true;

        }



    }
}
