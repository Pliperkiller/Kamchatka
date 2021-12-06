using UnityEngine.SceneManagement;

using UnityEngine;

public class SceneSkipPong : MonoBehaviour
{

    void Update()
    {
        if (Input.GetKeyDown("e"))
        {
            SceneManager.LoadScene("Pong", LoadSceneMode.Single);
        }

    }
}
