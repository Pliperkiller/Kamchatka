using UnityEngine.SceneManagement;

using UnityEngine;

public class StartTetris : MonoBehaviour
{
    [SerializeField] GameObject tTetris;

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
            SceneManager.LoadScene("IntroTetris", LoadSceneMode.Single);

        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            if (playerData.playerAnimalStatus == "Squirrel")
            {
                tTetris.SetActive(true);
                playerIsNear = true;


            }


        }
    }

    private void OnTriggerExit(Collider other)
    {
        tTetris.SetActive(false);
        playerIsNear = false;


    }
}
