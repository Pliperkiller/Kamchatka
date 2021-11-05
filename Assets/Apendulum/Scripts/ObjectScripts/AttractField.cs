using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractField : MonoBehaviour
{

    public GameObject Player;
    public float attforce;
    public float radius;
    private float objdist;
    private Transform TR;
    private Rigidbody RB;

    void Start()
    {
        TR = GetComponent<Transform>();
        RB = GetComponent<Rigidbody>();
    }

    void Update()
    {

        float objdist = Vector3.Distance(Player.transform.position, TR.position);

        if (objdist < radius)
        {
            RB.AddForce((Player.transform.position - TR.position) / (objdist* objdist* objdist) * attforce);

        }


        
    }
}
