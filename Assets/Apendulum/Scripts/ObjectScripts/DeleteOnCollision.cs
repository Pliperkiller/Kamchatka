using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeleteOnCollision : MonoBehaviour
{
    private int bandera = 1;
    private GameObject SceneController;
    private PlayerData playerData;
    private float destroyTimer = 0.0f;
    private bool setTimer;


    [SerializeField] AudioClip deleteClip;
    [SerializeField] AudioClip scoreClip;
    [SerializeField] AudioClip puzzleClip;

    private AudioSource audioSource;



    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<PlayerData>();


        audioSource = GetComponent<AudioSource>();
    }


    private void Update()
    {
        if(setTimer)
        {
            destroyTimer += Time.deltaTime;

            if (destroyTimer>1)
            {
                Destroy(gameObject);
            }

        }
        

    }

    private void OnCollisionEnter(Collision collision)
    {


        if (collision.gameObject.name == "Basket")
        {

            if (bandera == 1)
            {
                bandera++;
                playerData.points++;


                if(gameObject.name == "Puzzle(Clone)")
                {
                    playerData.puzzleOnBoard = false;
                    playerData.HasPuzzle = true;

                    audioSource.PlayOneShot(puzzleClip, 1f);


                }
                else
                {
                    audioSource.PlayOneShot(scoreClip, 1f);


                }


                setTimer = true;

            }

            
        }

        if (collision.gameObject.name == "Deadzone")
        {
            if (gameObject.name == "Puzzle(Clone)")
            {
                playerData.puzzleOnBoard = false;

            }
            audioSource.PlayOneShot(deleteClip,1f);


            setTimer = true;
        }
    }
}
