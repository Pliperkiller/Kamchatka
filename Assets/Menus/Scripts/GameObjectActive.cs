using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameObjectActive : MonoBehaviour
{
    public GameObject objectToGameObjectActive;
    public GameObject objetcToMenuActivation;
    public GameObject objectToFade;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Space))
        {
            objectToGameObjectActive.SetActive(false);
            objetcToMenuActivation.SetActive(true);
            objectToFade.SetActive(false);
        }
        else
        {
            objectToGameObjectActive.SetActive(true);
            objetcToMenuActivation.SetActive(false);
            objectToFade.SetActive(true);
        }
      
    }
}
