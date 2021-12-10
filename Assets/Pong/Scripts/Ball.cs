
using UnityEngine;

public class Ball : MonoBehaviour
{
    private Rigidbody rb;
    private float imp_x;
    private float imp_z;

    private GameObject sceneManager;
    private PongPlayerData playerData;

    private AudioSource audioSource;
    [SerializeField] AudioClip startGame;

    // Start is called before the first frame update
    void Start()
    {
        sceneManager = GameObject.FindGameObjectWithTag("GameController");
        playerData = sceneManager.GetComponent<PongPlayerData>();
        audioSource = GetComponent<AudioSource>();

        audioSource.PlayOneShot(startGame, 1f);


        rb = GetComponent<Rigidbody>();


        imp_x = Random.Range(7f, 10f)*Mathf.Sign(Random.Range(-1f,1f));
        imp_z = Random.Range(7f, 10f) * Mathf.Sign(Random.Range(-1f, 1f));
        

        rb.AddForce(new Vector3(imp_x, 0f, imp_z), ForceMode.Impulse);
    }

    private void Update()
    {
        if (playerData.gameIsPause)
        {

            rb.velocity = new Vector3(0f, 0f, 0f);


        }

    }
}
