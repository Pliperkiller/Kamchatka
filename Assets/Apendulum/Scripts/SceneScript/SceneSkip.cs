using UnityEngine;
using UnityEngine.SceneManagement;


public class SceneSkip : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown("e"))
        {
            SceneManager.LoadScene("Apendulum",LoadSceneMode.Single);
        }
    }
}
