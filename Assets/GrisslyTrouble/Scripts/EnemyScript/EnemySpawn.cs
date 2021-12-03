using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawn : MonoBehaviour
{
    [SerializeField] private GameObject[] enemies;
    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;
    private float timer;
    private float epsilon;
    private Vector3 SpawnLocation;
    private int RNG;
    private bool queenOnScene = false;


    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();

        timer = 0;
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        epsilon = Random.Range(-30.0f, 0.0f);

        if (timer+epsilon > 5 && PlayerData.roundIsActive)
        {
            SpawnLocation = transform.position;
            addEnemy(SpawnLocation);
            

            timer = 0;
        }



    }

    private void addEnemy(Vector3 position)
    {
        RNG = Random.Range(0, 50);
        if (RNG == 0 && queenOnScene == false && PlayerData.HasPuzzle == false)
        {
            Instantiate(enemies[1], transform.position, Quaternion.identity);
        }
        else
        {
            Instantiate(enemies[0], transform.position, Quaternion.identity);
        }

    }
}
