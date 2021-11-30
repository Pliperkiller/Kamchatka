using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Players : MonoBehaviour
{

    [SerializeField] bool isplayer1;
    [SerializeField] float speed = 5f;
    [SerializeField] Vector3 startPoss;

    // Start is called before the first frame update
    void Start()
    {
        startPoss = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        if (isplayer1)
        {

            transform.Translate(0f, Input.GetAxis("Vertical") * speed * Time.deltaTime, 0f);

        }
        else
        {

            transform.Translate(0f, Input.GetAxis("Vertical2") * speed * Time.deltaTime, 0f);

        }



    }

    // Resetear Posici�n 
    public void Reset()
    {
        transform.position = startPoss;
    }
}
