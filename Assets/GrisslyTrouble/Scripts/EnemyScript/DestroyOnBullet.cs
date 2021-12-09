
using UnityEngine;

public class DestroyOnBullet : MonoBehaviour
{
    [SerializeField] GameObject tomb;


    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Bullet")
        {


            Destroy(gameObject);

        }


    }


}
