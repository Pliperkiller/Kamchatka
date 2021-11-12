using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeleteOnCollision : MonoBehaviour
{
    private int bandera = 1;
    private GameObject SceneController;
    private PlayerData PlayerData;



    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<PlayerData>();

    }



    private void OnCollisionEnter(Collision collision)
    {


        if (collision.gameObject.name == "Basket")
        {

            if (bandera == 1)
            {
                bandera++;
                PlayerData.level++;
                PlayerData.points++;

                Destroy(gameObject);

            }

            
        }

        if (collision.gameObject.name == "Deadzone")
        {
            Destroy(gameObject);
        }
    }
}
