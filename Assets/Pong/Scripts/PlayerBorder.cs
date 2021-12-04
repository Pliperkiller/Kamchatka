using UnityEngine;

public class PlayerBorder : MonoBehaviour
{
    public ePlayer player;
    public ScoreUI score;
    [SerializeField] GameObject ballPref;
    private void OnCollisionEnter(Collision col)
    {
        Ball ball = col.gameObject.GetComponent<Ball>();

        if (ball != null)
        {
            Destroy(ball.gameObject);

            Instantiate(ballPref, new Vector3(0f, 1f, 0f), Quaternion.identity);


            if (player == ePlayer.Right) score.scorePlayerLeft++;
            else if (player == ePlayer.Left) score.scorePlayerRight++;

        }
    }
}
