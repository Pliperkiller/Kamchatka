using UnityEngine.SceneManagement;

using UnityEngine;

public class SceneSkipTetris : MonoBehaviour
{
    void Update()
    {

        if (Input.GetKeyDown("e"))
        {
            SceneManager.LoadScene("Tetris", LoadSceneMode.Single);
        }
    }
}
