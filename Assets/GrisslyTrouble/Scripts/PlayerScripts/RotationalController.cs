using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotationalController : MonoBehaviour
{
    public float rvelocity = 5.0f;
    public float svelocity = 5.0f;
    private Vector3 VelVector;
    private Vector3 RVector;
    private float h;
    private float v;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        h = Input.GetAxisRaw("Horizontal");
        v = Input.GetAxisRaw("Vertical");

        VelVector = new Vector3(0, 0, v * svelocity);
        RVector = new Vector3(0, h * rvelocity, 0);

        transform.Translate(VelVector * Time.deltaTime);
        transform.Rotate(RVector * Time.deltaTime);
    }
}
