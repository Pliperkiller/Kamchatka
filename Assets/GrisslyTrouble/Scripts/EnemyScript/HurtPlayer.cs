using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HurtPlayer : MonoBehaviour
{

    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;
    
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            PlayerData.health -= 5;

            Destroy(gameObject);

        }
    }


}
