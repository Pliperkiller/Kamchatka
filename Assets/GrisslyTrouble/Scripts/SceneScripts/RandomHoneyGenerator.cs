using UnityEngine;

public class RandomHoneyGenerator : MonoBehaviour
{
    [SerializeField] private GameObject honey;
    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;
    private GameObject[] honeys;

    public bool onCamp=false;
    private int level;
    private int amount = 20;
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
        if (Input.GetKeyDown("e") && PlayerData.nextLevel && onCamp)
        {
            honeys = GameObject.FindGameObjectsWithTag("Item");

            for (int i = 0; i < honeys.Length; i++)
            {
                Destroy(honeys[i]);
            }

            for (int i = 0; i < amount; i++)
            {
                Addhoney();
            }

            PlayerData.level++;



            PlayerData.nextLevel = false;
            PlayerData.honeyAmount = 0;


        }


    }

    private void Addhoney()
    {
        Vector3 position = new Vector3(Random.Range(-20, 20), 0.5f, Random.Range(-20, 20));
        Instantiate(honey, position, Quaternion.identity);
    }

    private void OnTriggerEnter(Collider other)
    {
        
        if (other.tag == "Player")
        {
            onCamp = true;
            PlayerData.onCamp = onCamp;

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            onCamp = false;
            PlayerData.onCamp = onCamp;


        }
    }
}


