using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractField : MonoBehaviour
{

    private GameObject Player;
    [SerializeField] private float attforce;
    [SerializeField] private float radius;
    private float objdist;
    private Transform TR;
    private Rigidbody RB;

    void Start()
    {
        Player = GameObject.FindWithTag("Player");
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

        Debug.Log(Player.transform.position);
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Destroy(this);
        }
    }
}
