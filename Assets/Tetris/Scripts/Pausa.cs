using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pausa : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            PausarJuego();
        }
    }

    public void PausarJuego ()
    {
        if (Time.timeScale == 1)
        {
            Time.timeScale = 0;
        }
        else
        {
            Time.timeScale = 1;

        }
    }
}
