using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HingeObject : MonoBehaviour
{
    private HingeJoint HJ;
    private Rigidbody RB;
    private Collider colid;
    private bool contact;
    private int bandera = 1;

    // Start is called before the first frame update
    void Start()
    {
        RB = GetComponent<Rigidbody>() as Rigidbody;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("e") && bandera==2)
        {
            Destroy(GetComponent<HingeJoint>());
            RB.useGravity = true;
            Destroy(this);
            bandera = 1;
        }
    }


    private void OnCollisionEnter(Collision collision)
    {

        if (collision.gameObject.tag == "Player")
        {
            if (bandera == 1)
            {
                addhinge(collision);
                bandera++;
            }

 
        }
    }
    private void addhinge(Collision collision)
    {
        HingeJoint HJ = gameObject.AddComponent<HingeJoint>() as HingeJoint;
        //HJ.anchor = collision.contacts[0].point;
        HJ.autoConfigureConnectedAnchor = true;
        HJ.connectedBody = collision.collider.attachedRigidbody;
    }
}
