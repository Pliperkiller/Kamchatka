using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Tetronimos : MonoBehaviour
{
    [SerializeField] private float tiempoCaida = 0.8f;
    private float tiempoAnterior;

    [SerializeField] private static int alto = 20;
    [SerializeField] private static int ancho = 10;

    [SerializeField] private Vector3 puntoRotation;

    private static Transform[,] grid = new Transform[ancho, alto];


    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            transform.position += new Vector3(-1, 0, 0);
            if (!Limites())
            {
                transform.position -= new Vector3(-1, 0, 0);
            }
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            transform.position += new Vector3(1, 0, 0);
            if (!Limites())
            {
                transform.position -= new Vector3(1, 0, 0);
            }
        }

        if (Time.time - tiempoAnterior > (Input.GetKey(KeyCode.S) ? tiempoCaida / 20 : tiempoCaida))
        {
            transform.position += new Vector3(0, -1, 0);

            if (!Limites())
            {
                transform.position -= new Vector3(0, -1, 0);

                AñadirAlGrid();

                this.enabled = false;
                FindObjectOfType<Generador>().NuevoTetromino();
            }

            tiempoAnterior = Time.time;
        }
    }



    bool Limites()
    {
        foreach (Transform hijo in transform)
        {
            int enteroX = Mathf.RoundToInt(hijo.transform.position.x);
            int enteroY = Mathf.RoundToInt(hijo.transform.position.y);

            if (enteroX < 0 || enteroX >= ancho || enteroY < 0 || enteroY >= alto)
            {
                return false;
            }

            if (grid[enteroX, enteroY] != null)
            {
                return false;
            }
        }

        return true;
    }


    void AñadirAlGrid()
    {
        foreach (Transform hijo in transform)
        {
            int enteroX = Mathf.RoundToInt(hijo.transform.position.x);
            int enteroY = Mathf.RoundToInt(hijo.transform.position.y);

            grid[enteroX, enteroY] = hijo;
        }
    }


}
