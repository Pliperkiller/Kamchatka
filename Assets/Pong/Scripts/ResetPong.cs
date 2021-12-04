using UnityEngine.SceneManagement;
using UnityEngine;

public class ResetPong : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKeyDown("r"))
        {
            SceneManager.LoadScene("Pong", LoadSceneMode.Single);

        }

    }
}
