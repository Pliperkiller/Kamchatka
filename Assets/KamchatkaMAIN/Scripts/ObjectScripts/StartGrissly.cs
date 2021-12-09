using UnityEngine.SceneManagement;
using UnityEngine;

public class StartGrissly : MonoBehaviour
{
    [SerializeField] GameObject tGrissly;

    private GameObject sceneController;
    private MainPlayerData playerData;

    private bool playerIsNear = false;

    private void Start()
    {
        sceneController = GameObject.Find("SceneController");
        playerData = sceneController.GetComponent<MainPlayerData>();


    }

    private void Update()
    {
        if (playerIsNear && Input.GetKey("f"))
        {
            SceneManager.LoadScene("IntroGrissly", LoadSceneMode.Single);

        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            if (playerData.playerAnimalStatus == "Bear")
            {
                tGrissly.SetActive(true);
                playerIsNear = true;


            }


        }
    }

    private void OnTriggerExit(Collider other)
    {
        tGrissly.SetActive(false);

    }
}
