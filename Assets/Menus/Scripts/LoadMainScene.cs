using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadMainScene : MonoBehaviour
{
    public void LoadScene(string sceneName)
    {
        if(sceneName== "MainMap")
        {
            Cursor.lockState = CursorLockMode.Locked;

        }

        SceneManager.LoadScene(sceneName);


    }
}