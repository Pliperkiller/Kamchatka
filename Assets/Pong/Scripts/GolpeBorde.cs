using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GolpeBorde : MonoBehaviour
{
    private AudioSource audioSource;
    [SerializeField] AudioClip ballHit;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        
        if(collision.gameObject.tag == "Item")
        {
            audioSource.PlayOneShot(ballHit, 1f);

        }

    }
}
