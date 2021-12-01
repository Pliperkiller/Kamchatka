using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PendulumStart : MonoBehaviour
{
    private Rigidbody RB;
    private Vector3 vo;
    private float epsilon;
    private float vel;


    // Start is called before the first frame update
    void Start()
    {

        epsilon = Random.Range(-2.0f, 2.0f);
        vel = 16.0f;

        vo = (vel + epsilon) * Vector3.right;

        RB = GetComponent<Rigidbody>();
        RB.AddForce(vo, ForceMode.VelocityChange);
    }

    // Update is called once per frame
    void Update()
    {

    }
}
