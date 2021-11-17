using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomTreeGenerator : MonoBehaviour
{
    [SerializeField] private GameObject[] sceneModels;
    [SerializeField] private int amount = 10;
    private Quaternion rotation = Quaternion.identity;

    // Start is called before the first frame update
    void Start()
    {

        Random.Range(0,1);

        for(int i = 0; i < amount; i++)
        {
            AddItem();
        }

    }

    private void AddItem()
    {
        rotation.Set(0, Random.Range(-1.0f, 1.0f), 0, 0);
        Vector3 position = new Vector3(Random.Range(-23, 23), 0.5f, Random.Range(-23, 23));
        Instantiate(sceneModels[Random.Range(0,sceneModels.Length)], position, rotation);
    }

}
