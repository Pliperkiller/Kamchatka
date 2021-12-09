using UnityEngine.SceneManagement;
using UnityEngine;

public class StartApendulum : MonoBehaviour
{
    [SerializeField] GameObject tApendulum;

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
            SceneManager.LoadScene("IntroApendulum", LoadSceneMode.Single);

        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
        {
            if(playerData.playerAnimalStatus == "Monkey")
            {           
                tApendulum.SetActive(true);
                playerIsNear = true;

                
            }


        }
    }

    private void OnTriggerExit(Collider other)
    {
        tApendulum.SetActive(false);

    }
}
