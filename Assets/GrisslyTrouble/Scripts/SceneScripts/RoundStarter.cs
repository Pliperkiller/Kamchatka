using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoundStarter : MonoBehaviour
{
    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;
    private GameObject[] enemies;
    private int bandera = 0;


    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();


    }

    // Update is called once per frame
    void Update()
    {
        enemies = GameObject.FindGameObjectsWithTag("Enemy");
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            PlayerData.roundIsActive = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            PlayerData.roundIsActive = false;

            for(int i = 0; i < enemies.Length; i++)
            {
                Destroy(enemies[i]);
            }

        }
    }
}
