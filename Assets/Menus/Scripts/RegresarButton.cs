using UnityEngine.SceneManagement;
using UnityEngine;

public class RegresarButton : MonoBehaviour
{

    private string previousScene;


    public void LoadPreviousScene()
    {
        previousScene = PlayerPrefs.GetString("EscenaAnterior");


        if (previousScene == "MainMap")
        {
            Cursor.lockState = CursorLockMode.Locked;

        }

        Time.timeScale = 1;
        SceneManager.LoadScene(previousScene);



    }

}
