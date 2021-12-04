using UnityEngine.SceneManagement;

using UnityEngine;

public class SkipScenePong : MonoBehaviour
{

    void Update()
    {
        if (Input.GetKeyDown("e"))
        {
            SceneManager.LoadScene("Pong", LoadSceneMode.Single);
        }

    }
}
