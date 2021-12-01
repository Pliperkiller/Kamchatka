using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
   [SerializeField] GameObject ball;

    [SerializeField] GameObject player1;
    [SerializeField] GameObject player1Goal;

    [SerializeField] GameObject player2;
    [SerializeField] GameObject player2Goal;

    [SerializeField] Text player1Text;
    [SerializeField] Text player2Text;

    private int player1Score;
    private int player2Score;

    [SerializeField] bool IAGame;


    //Puntuaci�n Player1
    public void Player1Scored()
    {
        player1Score++;
        player1Text.text = player1Score.ToString();
        ResetPosition();

    }

    //Puntuaci�n Player2
    public void Player2Scored()
    {
        player2Score++;
        player2Text.text = player2Score.ToString();
        ResetPosition();

    }

    // Resetear
    public void ResetPosition()
    {


        if (IAGame)
        {
            ball.GetComponent<Ball>().Reset();
            player2.GetComponent<Players>().Reset();
        }
        else
        {
            ball.GetComponent<Ball>().Reset();
            player1.GetComponent<Players>().Reset();
            player2.GetComponent<Players>().Reset();
        }
    }


}
