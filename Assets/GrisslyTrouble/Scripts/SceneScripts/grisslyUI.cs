using UnityEngine;
using TMPro;

public class grisslyUI : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI Tlevel;
    [SerializeField] TextMeshProUGUI Tpoints;
    [SerializeField] TextMeshProUGUI Tnextlevel;
    [SerializeField] TextMeshProUGUI Thealth;
    [SerializeField] TextMeshProUGUI Tammo;
    [SerializeField] TextMeshProUGUI Gpoints;

    [SerializeField] GameObject GameOverPanel;
    [SerializeField] GameObject NewLevelPanel;


    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;

    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();

    }

    // Update is called once per frame
    void Update()
    {
        Tlevel.text = PlayerData.level.ToString();
        Tpoints.text = PlayerData.points.ToString();
        Thealth.text = PlayerData.health.ToString();
        Tammo.text = PlayerData.ammo.ToString();

        if (PlayerData.honeyAmount < 11)
        {
            Tnextlevel.text = (PlayerData.honeyAmount*10).ToString() + "%";
        }



        if (PlayerData.Dead)
        {
            GameOverPanel.SetActive(true);
            Gpoints.text = Tpoints.text;

        }

        if (PlayerData.onCamp && PlayerData.nextLevel)
        {
            NewLevelPanel.SetActive(true);
        }
        else
        {
            NewLevelPanel.SetActive(false);
        }

    }
}
