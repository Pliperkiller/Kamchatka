using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class UIDisplay : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI Tlevel;
    [SerializeField] TextMeshProUGUI Tpoints;
    [SerializeField] TextMeshProUGUI Tnextlevel;
    [SerializeField] TextMeshProUGUI Gpoints;
    [SerializeField] GameObject GameOverPanel;

    private GameObject SceneController;
    private PlayerData PlayerData;

    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<PlayerData>();

    }

    // Update is called once per frame
    void Update()
    {
        Tlevel.text = PlayerData.level.ToString();
        Tpoints.text = PlayerData.points.ToString();


        if (PlayerData.Dead)
        {
            GameOverPanel.SetActive(true);
            Gpoints.text = Tpoints.text;

        }
    }
}
