using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ball : MonoBehaviour
{
    private Rigidbody rb;
    private float imp_x;
    private float imp_z;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();


        imp_x = Random.Range(7f, 10f)*Mathf.Sign(Random.Range(-1f,1f));
        imp_z = Random.Range(7f, 10f) * Mathf.Sign(Random.Range(-1f, 1f));
        

        rb.AddForce(new Vector3(imp_x, 0f, imp_z), ForceMode.Impulse);
    }

}
