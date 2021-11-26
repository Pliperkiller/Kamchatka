using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimalConversion : MonoBehaviour
{
    private MainPlayerData playerData;
    private GameObject SceneController;
    private GameObject newModel;

    [SerializeField] private GameObject[] animalPrefabs;

    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<MainPlayerData>();


        Destroy(GameObject.FindWithTag("PlayerModel"));
        newModel = Instantiate(animalPrefabs[0]);
        newModel.transform.SetParent(transform, false);



    }

    // Update is called once per frame
    void Update()
    {
        
        if (Input.GetKeyDown("e"))
        {
            morph("Monkey");
        }

        Debug.Log(playerData.playerAnimalStatus);

    }

    private void morph(string target)
    {
        if (target == "Monkey" && playerData.playerAnimalStatus != "Monkey")
        {
            Destroy(GameObject.FindWithTag("PlayerModel"));

            newModel = Instantiate(animalPrefabs[1]);
            newModel.transform.SetParent(transform,false);

            playerData.playerAnimalStatus = "Monkey";
        }

        if (target == "Bear" && playerData.playerAnimalStatus != "Bear")
        {
            Destroy(GameObject.FindWithTag("PlayerModel"));

            newModel = Instantiate(animalPrefabs[2]);
            newModel.transform.SetParent(transform, false);

            playerData.playerAnimalStatus = "Monkey";
        }

        if (target == "Squirrel" && playerData.playerAnimalStatus != "Squirrel")
        {
            Destroy(GameObject.FindWithTag("PlayerModel"));

            newModel = Instantiate(animalPrefabs[3]);
            newModel.transform.SetParent(transform, false);

            playerData.playerAnimalStatus = "Monkey";
        }

        if (target == "Otter" && playerData.playerAnimalStatus != "Otter")
        {
            Destroy(GameObject.FindWithTag("PlayerModel"));

            newModel = Instantiate(animalPrefabs[4]);
            newModel.transform.SetParent(transform, false);

            playerData.playerAnimalStatus = "Monkey";
        }

    }

}
