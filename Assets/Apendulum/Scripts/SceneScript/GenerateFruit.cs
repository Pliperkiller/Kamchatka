using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateFruit : MonoBehaviour
{
    [SerializeField] private GameObject fruit;
    private float xpos;
    private float ypos;
    private float zpos;
    private Vector3 pos;


    // Start is called before the first frame update
    void Start()
    {
        xpos = Random.Range(0.0f, 35.0f);
        ypos = Random.Range(2.0f, 7.0f);
        zpos = 0;

        pos = new Vector3(xpos, ypos, zpos);

        NuevaFruta(pos);

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void NuevaFruta(Vector3 position)
    {
        Instantiate(fruit,position,Quaternion.identity);
    }


}
