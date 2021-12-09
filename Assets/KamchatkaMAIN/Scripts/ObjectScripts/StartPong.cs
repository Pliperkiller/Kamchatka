using UnityEngine.SceneManagement;
using UnityEngine;


public class StartPong : MonoBehaviour
{
    [SerializeField] GameObject tPong;

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
            SceneManager.LoadScene("IntroPong", LoadSceneMode.Single);

        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            if (playerData.playerAnimalStatus == "Otter")
            {
                tPong.SetActive(true);
                playerIsNear = true;


            }


        }
    }

    private void OnTriggerExit(Collider other)
    {
        tPong.SetActive(false);

    }
}
