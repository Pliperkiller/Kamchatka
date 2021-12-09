using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public float bspeed = 15;
    public float tlong = 6;
    private Rigidbody rb;

    [SerializeField] AudioClip deadBeeClip;

    private AudioSource audioSource;

    void Start()
    {
        rb = gameObject.GetComponent<Rigidbody>();
        rb.velocity = transform.forward * bspeed;

        audioSource = GetComponent<AudioSource>();
    }

    void Update()
    {
        if (tlong > 0)
        {
            tlong += -Time.deltaTime;
        }
        else
        {

            Destroy(gameObject);
        }
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Enemy")
        {
            audioSource.PlayOneShot(deadBeeClip, 1f);

        }

    }

}
