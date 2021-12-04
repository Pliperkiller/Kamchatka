using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum ePlayer
{
    Left,
    Right
}

public class Player : MonoBehaviour
{

    [SerializeField] private float speed = 15f;
    public ePlayer player;

    private float verticalInput;

    private Rigidbody rb;



    private void Start()
    {

        rb = GetComponent<Rigidbody>();



    }
    void Update()
    {
        verticalInput = Input.GetAxis("Vertical");

        rb.velocity = (speed *verticalInput * Vector3.forward);



        
    }
}
