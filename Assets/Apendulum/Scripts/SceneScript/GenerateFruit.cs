using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateFruit : MonoBehaviour
{
    [SerializeField] private GameObject fruit;
    private GameObject item;
    private float xpos;
    private float ypos;
    private float zpos;
    private Vector3 pos;
    private GameObject SceneController;
    private PlayerData PlayerData;
    private GameObject[] gos;


    // Start is called before the first frame update
    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<PlayerData>();

        for (int i = 0; i < 5; i++)
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
        int left = 5 - gos.Length;

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
        Instantiate(fruit,position,Quaternion.identity);
    }


}
