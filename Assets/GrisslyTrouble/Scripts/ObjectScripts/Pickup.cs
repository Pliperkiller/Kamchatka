using UnityEngine;

public class Pickup : MonoBehaviour
{

    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;

    public GameObject Player;
    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();

    }

    private void Update()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            if (gameObject.name == "Puzzle(Clone)")
            {
                PlayerData.HasPuzzle = true;

            }
            PlayerData.points++;
            PlayerData.honeyAmount++;
            Destroy(gameObject);
        }
    }
}
