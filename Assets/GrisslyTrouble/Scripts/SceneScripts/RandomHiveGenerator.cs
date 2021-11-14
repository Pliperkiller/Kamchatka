using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomHiveGenerator : MonoBehaviour
{
    [SerializeField] private GameObject hive;
    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;
    private GameObject[] Hives;
    private int level;
    private int hives;
    private int bandera=1;

    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();

        level = PlayerData.level;
        hives = 3;

        for (int i = 0; i < hives + level; i++)
        {
            Addhive();
        }
        bandera = 1;

    }

    private void Addhive()
    {
        Vector3 position = new Vector3(Random.Range(-25, 25), 0.5f, Random.Range(-25, 25));
        Instantiate(hive, position, Quaternion.identity);
    }

    private void OnTriggerExit(Collider other)
    {
        level = PlayerData.level;
        if (other.tag == "Player" && bandera == 0)
        {
            for (int i = 0;i< hives + level;i++)
            {
                Addhive();
            }
            bandera = 1;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        level = PlayerData.level;
        if (other.tag == "Player" && bandera == 1)
        {
            Hives = GameObject.FindGameObjectsWithTag("EnemySpawn");

            for (int i = 0; i < hives + level; i++)
            {
                Destroy(Hives[i]);
            }
            bandera = 0;
        }
    }



}
