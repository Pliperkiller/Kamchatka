using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractField : MonoBehaviour
{

    private GameObject Player;
    [SerializeField] private float speed;
    [SerializeField] private float radius;
    private float objdist;
    private int Bandera=0;

    void Start()
    {
        Player = GameObject.FindWithTag("Player");
    }

    void Update()
    {

        float objdist = Vector3.Distance(Player.transform.position, transform.position);

        if (objdist < radius)
        {
            Bandera = 1;

        }

        if (Bandera == 1)
        {
            transform.position = Vector3.MoveTowards(transform.position, Player.transform.position, speed*Time.deltaTime);
        }
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            Destroy(this);
        }
    }
}
