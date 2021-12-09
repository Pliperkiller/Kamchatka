using UnityEngine;

public class Shooting : MonoBehaviour
{
    [SerializeField] private GameObject Playergun;
    [SerializeField] private GameObject Bullet;

    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;

    private bool shootdown;

    [SerializeField] AudioClip shootClip;
    [SerializeField] AudioClip levelUpClip;

    private AudioSource audioSource;


    private void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();

        audioSource = GetComponent<AudioSource>();


    }
    void Update()
    {
        if (PlayerData.pauseStatus == false)
        {
            shootdown = Input.GetMouseButtonDown(0);


            if (shootdown & (PlayerData.ammo > 0))
            {
                Instantiate(Bullet, Playergun.transform.position, Playergun.transform.rotation);

                PlayerData.ammo += -1;

                audioSource.PlayOneShot(shootClip, 0.7f);
            }

            if (Input.GetKeyDown("e") && PlayerData.onCamp)
            {
                PlayerData.ammo = 100;

                audioSource.PlayOneShot(levelUpClip, 1f);
            }

        }



    }

}
