
using UnityEngine;
using UnityEngine.SceneManagement;


public class PauseGame : MonoBehaviour
{
    public GameObject PauseMenu;
    public bool JuegoPausado = false;

    private void PauseButton()
    {
        PauseMenu.SetActive(true);
        Time.timeScale = 0;
        Cursor.lockState = CursorLockMode.None;

    }
    private void PlayButton()
    {

        PauseMenu.SetActive(false);
        Time.timeScale = 1;
        if (SceneManager.GetActiveScene().name != "GrisslyTrouble")
        {
            Cursor.lockState = CursorLockMode.Locked;


        }

    }

    private void Update()
    {
        if (SceneManager.GetActiveScene().name != "Intro")
        {

            if (Input.GetKeyUp(KeyCode.Escape) && JuegoPausado == true)
            {
                JuegoPausado = false;
                PlayButton();

            }
            else if (Input.GetKeyUp(KeyCode.Escape) && JuegoPausado == false)
            {
                JuegoPausado = true;
                PauseButton();

            }

        }
        else
        {
            Application.Quit();

        }

    }


}
