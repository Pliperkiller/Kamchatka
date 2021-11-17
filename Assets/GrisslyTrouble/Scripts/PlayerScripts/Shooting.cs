using UnityEngine;

public class Shooting : MonoBehaviour
{
    [SerializeField] private GameObject Playergun;
    [SerializeField] private GameObject Bullet;

    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;

    private int ammo = 100;

    private void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();
    }
    void Update()
    {
        bool shootdown = Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0);
        if ( shootdown & (ammo>0))
        {
            Instantiate(Bullet, Playergun.transform.position, Playergun.transform.rotation);
            
            ammo += -1;
        }

        if (Input.GetKeyDown("e") && PlayerData.onCamp)
        {
            ammo = 100;
        }

    }
}
