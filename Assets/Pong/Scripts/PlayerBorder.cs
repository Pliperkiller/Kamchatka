using UnityEngine;
using TMPro;

public class PlayerBorder : MonoBehaviour
{
    public ePlayer player;
    public ScoreUI score;

    [SerializeField] private GameObject ballPref;
    private float time;
    private bool ballOnBoard = true;
    [SerializeField] private TextMeshProUGUI textTimer;


    private void Update()
    {
      

        if (ballOnBoard == false)
        {
            time += Time.deltaTime*1.1f;

            textTimer.text = (3-(int)time).ToString();

            if (time >= 3)
            {
                Instantiate(ballPref, new Vector3(0f, 1f, 0f), Quaternion.identity);

                ballOnBoard = true;

                textTimer.text = " ";

                time = 0;
            }

        }



    }
    private void OnCollisionEnter(Collision col)
    {
        Ball ball = col.gameObject.GetComponent<Ball>();

        if (ball != null)
        {
            Destroy(ball.gameObject);

            ballOnBoard = false;


            if (player == ePlayer.Right) score.scorePlayerLeft++;
            else if (player == ePlayer.Left) score.scorePlayerRight++;

        }
    }
}
