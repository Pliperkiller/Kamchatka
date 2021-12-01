using UnityEngine;
using UnityEngine.SceneManagement;


public class SceneSkipGrissly : MonoBehaviour
{

    void Update()
    {

        if (Input.GetKeyDown("e"))
        {
            SceneManager.LoadScene("GrisslyTrouble", LoadSceneMode.Single);
        }
    }
}
