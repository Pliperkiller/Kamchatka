using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ball : MonoBehaviour
{
    [SerializeField] float speed = 5f;
    private Vector2 startpos;




    // Start is called before the first frame update
    void Start()
    {
        float sx= Random.Range(0, 2) == 0 ? -1 : 1;
        float sy = Random.Range(0, 2) == 0 ? -1 : 1;
        GetComponent<Rigidbody>().velocity = new Vector3(speed * sx, speed * sy, 0f);
        transform.position = startpos;
        
    }

    // Primer Lanzamiento de la bola
   

    //Resetear posici�n de la pelota
    public void Reset()
    {
        transform.position = startpos;
    }
}