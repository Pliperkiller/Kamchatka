using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HingePlayer : MonoBehaviour
{
    private bool contact=false;
    public int conected=0;
    private HingeJoint HJ;
    private Collider item;

    // Start is called before the first frame update
    void Start()
    {
        HJ=GetComponent<HingeJoint>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) & contact)
        {
            if (conected == -1)
            {
               HingeJoint HJ = gameObject.AddComponent<HingeJoint>() as HingeJoint;
                HJ.anchor = new Vector3(0, 1.2f, 0);
                HJ.autoConfigureConnectedAnchor = true;
                HJ.connectedBody = item.attachedRigidbody;
            }

            if (conected == 0)
            {
                HJ.connectedBody = item.attachedRigidbody;
            }


            conected = 1;

        }


        if (Input.GetKeyUp(KeyCode.Space))
        {
            if (conected == 1)
            {
                Destroy(GetComponent<HingeJoint>());
                conected = -1;
            }

            
        }

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Pendulum")
        {
            contact = true;
            item = other;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Pendulum")
        {
            contact = false;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.tag == "Pendulum")
        {
            contact = true;
            item = other;

        }
    }

}
