using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBorder : MonoBehaviour
{
    public ePlayer player;
    public ScoreUI score;
    private void OnCollisionEnter(Collision col)
    {
        Ball ball = col.gameObject.GetComponent<Ball>();

        if (ball != null)
        {
            ball.transform.position = new Vector3(0f, 1f, 0f);

            if (player == ePlayer.Right) score.scorePlayerLeft++;
            else if (player == ePlayer.Left) score.scorePlayerRight++;

        }
    }
}
