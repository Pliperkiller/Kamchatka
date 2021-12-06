
using UnityEngine;

public class PongPlayerData : MonoBehaviour
{
    public int playerScore;
    public int rivalScore;


    public string playerStatus="NAN";

    public bool gameIsPause = false;
    public bool otterPuzzle;

    
    void Start()
    {
        playerScore = 0;


    }

    // Update is called once per frame
    void Update()
    {
        if(playerScore == 10)
        {
            playerStatus = "Win";
            otterPuzzle = true;
            gameIsPause = true;

        }
        else if(rivalScore == 10)
        {
            playerStatus = "Lose";
            gameIsPause = true;



        }

    }
}
