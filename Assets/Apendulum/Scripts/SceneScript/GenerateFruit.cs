using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateFruit : MonoBehaviour
{
    [SerializeField] private GameObject fruit;
    [SerializeField] private GameObject puzzle;
    [SerializeField] private int amount;
    private GameObject item;
    private float xpos;
    private float ypos;
    private float zpos;
    private Vector3 pos;
    private GameObject SceneController;
    private PlayerData playerData;
    private GameObject[] gos;
    private bool pieceOnScene = false;
    private int RNG;

    


    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<PlayerData>();
        amount = 4;

        for (int i = 0; i < amount; i++)
        {
            xpos = Mathf.Sign(Random.Range(-1.0f, 1.0f)) * 27 * Mathf.Sin(6.28f * Random.Range(0, 12) / 12) + Random.Range(-2.0f, 2.0f);
            ypos = Random.Range(2.0f, 7.0f);
            zpos = 0;

            pos = new Vector3(xpos, ypos, zpos);

            NuevaFruta(pos);
        }

    }

    // Update is called once per frame
    void Update()
    {
        gos = GameObject.FindGameObjectsWithTag("Item");
        int left = amount - gos.Length;

        if (left!=0)
        {
            

            for(int i = 0; i < left; i++)
            {

                xpos = Mathf.Sign(Random.Range(-1.0f, 1.0f)) * 27 * Mathf.Sin(6.28f * Random.Range(0, 12) / 12) + Random.Range(-2.0f, 2.0f);
                ypos = Random.Range(2.0f, 7.0f);
                zpos = 0;

                pos = new Vector3(xpos, ypos, zpos);

                NuevaFruta(pos);
            }
            

            item = GameObject.FindWithTag("Item");
        }

    }

    public void NuevaFruta(Vector3 position)
    {
        RNG = Random.Range(0, 5);

        if ((RNG == 0) && (playerData.HasPuzzle == false) && (playerData.puzzleOnBoard==false) && (playerData.points>1))
        {
            Instantiate(puzzle, position, Quaternion.identity);
            playerData.puzzleOnBoard = true;

        }
        else
        {
            Instantiate(fruit, position, Quaternion.identity);

        }

    }


}
