using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Generador : MonoBehaviour
{
    [SerializeField] private GameObject[] tetrominos;

    void Start()
    {
        NuevoTetromino();
    }

    void Update()
    {

    }

    public void NuevoTetromino()
    {
        Instantiate(tetrominos[Random.Range(0, tetrominos.Length)], transform.position, Quaternion.identity);
    }
}
