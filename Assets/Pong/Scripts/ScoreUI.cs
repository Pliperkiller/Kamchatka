using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreUI : MonoBehaviour

{

    public int scorePlayerRight;
    public int scorePlayerLeft;
    public GUIStyle style;
    [SerializeField] private GameObject GameOverPanel;
    [SerializeField] private GameObject WinPanel;

    private void OnGUI()
    {
        float x = Screen.width / 2f;
        float y = 30f;
        float width = 300f;
        float height = 20f;
        string text = scorePlayerLeft + " / " + scorePlayerRight;

        GUI.Label(new Rect(x - (width / 2f), y, width, height), text, style);
    }

    void Update()
    {

        if (scorePlayerLeft==10)
        {
            GameOverPanel.SetActive(true);

        } else if (scorePlayerRight==10)
        {
            WinPanel.SetActive(true);

        }
    }

}

