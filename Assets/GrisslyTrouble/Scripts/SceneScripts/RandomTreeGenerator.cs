using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomTreeGenerator : MonoBehaviour
{
    [SerializeField] private GameObject[] sceneModels;
    [SerializeField] private int amount = 10;

    // Start is called before the first frame update
    void Start()
    {

        Random.Range(0,1);

        for(int i = 0; i < amount; i++)
        {
            AddItem();
        }

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void AddItem()
    {
        Vector3 position = new Vector3(Random.Range(-25, 25), 0.5f, Random.Range(-25, 25));
        Instantiate(sceneModels[Random.Range(0,sceneModels.Length)], position, Quaternion.identity);
    }

}
