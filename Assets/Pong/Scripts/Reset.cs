using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Resetear : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKeyDown("r"))
        {
            SceneManager.LoadScene("SuperPong", LoadSceneMode.Single);

        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            

        }
    }
}
