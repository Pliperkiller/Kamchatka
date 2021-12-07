using TMPro;
using UnityEngine;

public class TetrisPlayerData : MonoBehaviour
{
    public int score=0;
    public bool squirrelPuzzle;

    public string playerStatus = "NAN";

    [SerializeField] private TextMeshProUGUI Tpoints;
    [SerializeField] private TextMeshProUGUI Gpoints;

    [SerializeField] private GameObject gameOverPanel;
    [SerializeField] private GameObject winPanel;



    // Update is called once per frame
    void Update()
    {

        Tpoints.text = "Puntaje: " + score.ToString();

        if (score >= 20)
        {
            playerStatus = "Win";

        }


        if(playerStatus == "Win")
        {
            winPanel.SetActive(true);
            squirrelPuzzle = true;


        }

        if(playerStatus == "Lose")
        {
            Gpoints.text = score.ToString();
            gameOverPanel.SetActive(true);


        }


    }
}
