using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public float bspeed = 15;
    public float tlong = 6;
    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        rb = gameObject.GetComponent<Rigidbody>();
        rb.velocity = transform.forward * bspeed;
    }

    // Update is called once per frame
    void Update()
    {
        if (tlong > 0)
        {
            tlong += -Time.deltaTime;
        }
        else
        {
            Debug.Log("Destroy");
            Destroy(gameObject);
        }
        
    }
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Enemy")
        {
            Destroy(gameObject);
        }
    }
}
