
using UnityEngine;

public class IA : MonoBehaviour
{
    [SerializeField] private  float speed =3;
    private GameObject ball;

    private Vector3 ballPosition;



    // Update is called once per frame
    void Update()
    {
        ball = GameObject.FindWithTag("Item");
        if(ball != null)
        {
            move();


        }
  
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
