using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomHoneyGenerator : MonoBehaviour
{
    [SerializeField] private GameObject honey;
    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;
    private GameObject[] honeys;
    private int level;
    private int amount=20;
    private int bandera = 1;

    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();

        for (int i = 0; i < amount; i++)
        {
            Addhoney();
        }

        honeys = GameObject.FindGameObjectsWithTag("Item");


    }

    // Update is called once per frame
    void Update()
    {
        honeys = GameObject.FindGameObjectsWithTag("Item");
    }

    private void Addhoney()
    {
        Vector3 position = new Vector3(Random.Range(-25, 25), 0.5f, Random.Range(-25, 25));
        Instantiate(honey, position, Quaternion.identity);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player" && bandera==1 && PlayerData.nextLevel)
        {
            for (int i = 0; i < honeys.Length; i++)
            {
                Destroy(honeys[i]);
            }

            PlayerData.level++;

            Debug.Log("Level: " + PlayerData.level);

            PlayerData.nextLevel = false;
            PlayerData.honeyAmount = 0;

            bandera = 0;

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player" && bandera == 0 && PlayerData.nextLevel==false)
        {
            for (int i = 0; i < amount; i++)
            {
                Addhoney();
            }

            bandera = 1;

        }
    }
}


