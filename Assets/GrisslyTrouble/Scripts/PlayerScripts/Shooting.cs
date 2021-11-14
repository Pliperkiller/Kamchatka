using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooting : MonoBehaviour
{
    public GameObject Playergun;
    public GameObject Bullet;
    private int ammo = 100;

    void Update()
    {
        bool shootdown = Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0);
        if ( shootdown & (ammo>0))
        {
            Instantiate(Bullet, Playergun.transform.position, Playergun.transform.rotation);
            
            ammo += -1;
        }

        if (Input.GetKeyDown("r"))
        {

            ammo = 100;

        }

    }
}
