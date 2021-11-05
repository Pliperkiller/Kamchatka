using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooting : MonoBehaviour
{
    public GameObject Playergun;
    public GameObject Bullet;
    private int ammo = 4;

    // Start is called before the first frame update
    void Start()
    {
 
    }

    // Update is called once per frame
    void Update()
    {
        bool shootdown = Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0);
        if ( shootdown & (ammo>0))
        {
            Instantiate(Bullet, Playergun.transform.position, Playergun.transform.rotation);
            Debug.Log("Shoot!");
            ammo += -1;
        }

        if (Input.GetKeyDown("r"))
        {
            Debug.Log("Reload ammo");
            ammo = 4;

        }

    }
}
