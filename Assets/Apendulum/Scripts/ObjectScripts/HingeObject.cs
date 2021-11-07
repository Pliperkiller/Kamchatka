using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HingeObject : MonoBehaviour
{
    private HingeJoint HJ;
    private Collider colid;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            addhinge(collision);
        }
    }
    private void addhinge(Collision collision)
    {
        HingeJoint HJ = gameObject.AddComponent<HingeJoint>() as HingeJoint;
        HJ.anchor = collision.contacts[0].point;
        HJ.autoConfigureConnectedAnchor = true;
        HJ.connectedBody = collision.collider.attachedRigidbody;
    }
}
