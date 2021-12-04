using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeleteOnCollision : MonoBehaviour
{
    private int bandera = 1;
    private GameObject SceneController;
    private PlayerData playerData;



    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<PlayerData>();
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
                }

                Destroy(gameObject);

            }

            
        }

        if (collision.gameObject.name == "Deadzone")
        {
            if (gameObject.name == "Puzzle(Clone)")
            {
                playerData.puzzleOnBoard = false;

            }

            Destroy(gameObject);
        }
    }
}
