using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IA : MonoBehaviour
{
    [SerializeField] private  float speed =3;
    [SerializeField] private GameObject ball;

    private Vector3 ballPosition;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        move();
    }

    void move()
    {
        ballPosition = ball.transform.position;

        if(transform.position.z > ballPosition.z)
        {
            transform.position += new Vector3(0,0,-speed*Time.deltaTime);
        }
        if (transform.position.z < ballPosition.z)
        {
            transform.position += new Vector3(0, 0, speed * Time.deltaTime);

        }
    }
}
