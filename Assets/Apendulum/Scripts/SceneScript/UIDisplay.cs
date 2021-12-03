using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UIDisplay : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI Tpoints;
    [SerializeField] private Text Gpoints;
    [SerializeField] private GameObject GameOverPanel;

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
        Tpoints.text = "Puntaje: " + PlayerData.points.ToString();


        if (PlayerData.Dead)
        {
            GameOverPanel.SetActive(true);
            Gpoints.text = PlayerData.points.ToString();

        }
    }
}
