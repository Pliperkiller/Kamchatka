
using UnityEngine;

public class KillPlayer : MonoBehaviour
{
    private GameObject SceneController;
    private PlayerData PlayerData;

    [SerializeField] AudioClip deadClip;
    private AudioSource audioSource;


    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<PlayerData>();

        audioSource = GetComponent<AudioSource>();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            PlayerData.Dead = true;

            audioSource.PlayOneShot(deadClip, 1f);


        }
    }
}
