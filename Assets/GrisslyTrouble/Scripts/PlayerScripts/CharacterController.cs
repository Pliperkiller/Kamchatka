using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterController : MonoBehaviour
{
    public float velocity = 5.0f;
    public float jforce = 2.0f;
    private Vector3 VelVector;
    private Vector3 fvector;
    private bool onfloor = false;
    private Rigidbody RB;
    private float h;
    private float v;

     void Start()
    {
        RB = GetComponent<Rigidbody>();

    }


    void Update()
    {

        h = Input.GetAxisRaw("Horizontal");
        v = Input.GetAxisRaw("Vertical");

        VelVector = new Vector3(h * velocity, 0, v * velocity);
        fvector = new Vector3(0,1,0) * jforce;

        transform.Translate(VelVector * Time.deltaTime, Space.World);

        if (Input.GetKeyDown(KeyCode.Space) & onfloor)
        {
            RB.AddForce(fvector);
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Floor")
        {
            Debug.Log("On Floor");
            onfloor = true;
        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.tag == "Floor")
        {
            Debug.Log("On Air");
            onfloor = false;
        }
    }
}
