using UnityEngine;

public class AnimalConversion : MonoBehaviour
{
    private MainPlayerData playerData;
    private GameObject SceneController;
    private GameObject newModel;
    private GameObject targetModel;


    [SerializeField] private GameObject[] animalPrefabs;

    public bool interactPosible;

    
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<MainPlayerData>();


        Destroy(GameObject.FindWithTag("PlayerModel"));
        newModel = Instantiate(animalPrefabs[0]);
        newModel.transform.SetParent(transform, false);



    }

    
    void Update()
    {     
        if (Input.GetKeyDown("e") && interactPosible)
        {
            morph(targetModel.name);

        }

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

            playerData.playerAnimalStatus = "Bear";
        }

        if (target == "Squirrel" && playerData.playerAnimalStatus != "Squirrel")
        {
            Destroy(GameObject.FindWithTag("PlayerModel"));

            newModel = Instantiate(animalPrefabs[3]);
            newModel.transform.SetParent(transform, false);

            playerData.playerAnimalStatus = "Squirrel";
        }

        if (target == "Otter" && playerData.playerAnimalStatus != "Otter")
        {
            Destroy(GameObject.FindWithTag("PlayerModel"));

            newModel = Instantiate(animalPrefabs[4]);
            newModel.transform.SetParent(transform, false);

            playerData.playerAnimalStatus = "Otter";
        }

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "NPC"){

            interactPosible = true;
            targetModel = other.gameObject;


        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "NPC")
        {

            interactPosible = false;


        }
    }

}
