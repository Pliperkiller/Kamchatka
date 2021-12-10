using UnityEngine.SceneManagement;

using UnityEngine;

public class ExitCredits : MonoBehaviour
{


    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {

            SceneManager.LoadScene("Intro");

        }


    }
}
