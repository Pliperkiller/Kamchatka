using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public GameObject PauseMenu;
    private bool JuegoPausado = false;

    public void PauseButton()
    {
        PauseMenu.SetActive(true);
        
    }
    public void PlayButton()
    {
        PauseMenu.SetActive(false);
        
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.Escape))
        {
            if (JuegoPausado)
            {
                PlayButton();
            }
            else
            {
                PauseButton();
            }
        }
    }
}
