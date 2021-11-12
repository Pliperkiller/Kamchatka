using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomMass : MonoBehaviour
{
    private float mass=20;
    private float epsilon;
    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();

        epsilon = Random.Range(-5.0f,5.0f);

        rb.mass = mass + epsilon;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
