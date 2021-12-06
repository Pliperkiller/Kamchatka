using UnityEngine;
using TMPro;

public class ScoreUI : MonoBehaviour

{

    public int scorePlayerRight;
    public int scorePlayerLeft;
    public GUIStyle style;
    [SerializeField] private GameObject GameOverPanel;
    [SerializeField] private GameObject WinPanel;
    [SerializeField] private GameObject UI;

    [SerializeField] private TextMeshProUGUI scoreLeft;
    [SerializeField] private TextMeshProUGUI scoreRight;

    private GameObject sceneManager;
    private PongPlayerData playerData;

    private void Start()
    {
        sceneManager = GameObject.FindGameObjectWithTag("GameController");
        playerData = sceneManager.GetComponent<PongPlayerData>();
    }


    void Update()
    {
        scoreLeft.text = "Puntaje: " + scorePlayerLeft.ToString();
        scoreRight.text = "Puntaje: " + scorePlayerRight.ToString();

        playerData.playerScore = scorePlayerRight;


        if (scorePlayerLeft==10)
        {
            UI.SetActive(false);
            GameOverPanel.SetActive(true);

            playerData.playerStatus = "Win";


        }
        else if (scorePlayerRight==10)
        {
            UI.SetActive(false);
            WinPanel.SetActive(true);

            playerData.playerStatus = "Lose";

        }
    }

}

