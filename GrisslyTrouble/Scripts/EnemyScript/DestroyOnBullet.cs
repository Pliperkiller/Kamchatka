using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnBullet : MonoBehaviour
{
    [SerializeField] GameObject puzzle;


    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Bullet")
        {
            Destroy(gameObject);

            if (gameObject.name == "QueenBee(Clone)")
            {
                Instantiate(puzzle, gameObject.transform.position, Quaternion.identity);

                
            }

        }


    }
}
