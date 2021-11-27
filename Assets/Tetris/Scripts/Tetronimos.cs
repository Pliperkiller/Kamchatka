using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;


public class Tetronimos : MonoBehaviour
{
    [SerializeField] private float tiempoCaida = 0.8f;
    private float tiempoAnterior;

    [SerializeField] private static int alto = 20;
    [SerializeField] private static int ancho = 20;

    [SerializeField] private Vector3 puntoRotation;

    private static Transform[,] grid = new Transform[ancho, alto];

    [SerializeField] public static int puntaje = 0;

    [SerializeField] public static int nivelDeDificultad = 0;



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

                A�adirAlGrid();
                RevisarLineas();

                this.enabled = false;
                FindObjectOfType<Generador>().NuevoTetromino();
            }

            tiempoAnterior = Time.time;
        }

        if (Input.GetKeyDown(KeyCode.W))
        {
            transform.RotateAround(transform.TransformPoint(puntoRotation), new Vector3(0,0,1), -90);
            if (!Limites())
            {
                transform.RotateAround(transform.TransformPoint(puntoRotation), new Vector3(0, 0, 1), 90);
            }
        }

        AumentarNivel();
        AumentarDificultad();

        
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


    void A�adirAlGrid()
    {
        foreach (Transform hijo in transform)
        {
            int enteroX = Mathf.RoundToInt(hijo.transform.position.x);
            int enteroY = Mathf.RoundToInt(hijo.transform.position.y);

            grid[enteroX, enteroY] = hijo;

            if (enteroY >= 19)
            {
                puntaje = 0;
                nivelDeDificultad = 0;
                tiempoCaida = 0.8f;

                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
            }
        }
    }


    void RevisarLineas()
    {
        for (int i = alto - 1 ; i >= 0; i--)
        {
            if (TieneLinea(i))
            {
                BorrarLinea(i);
                BajarLinea(i);
            }
        }
    }

    bool TieneLinea(int i)
    {
        for (int j = 0; j < ancho; j++)
        {
            if (grid[j,i] == null)
            {
                return false;
            }
        }

        puntaje += 1;
        Debug.Log(puntaje);

        return true;
    }

    void BorrarLinea (int i)
    {
        for (int j = 0; j < ancho; j++)
        {
            Destroy(grid[j, i].gameObject);
            grid[j, i] = null;
        }
    }

    void BajarLinea (int i)
    {
        for (int y = i; y < alto; y++)
        {
            for (int j = 0; j < ancho; j++)
            {
                if (grid[j,y] != null)
                {
                    grid[j, y - 1] = grid[j,y];
                    grid[j, y] = null;
                    grid[j, y - 1].transform.position-= new Vector3(0,1,0);
                }
            }
        }
    }

    void AumentarNivel ()
    {
        switch(puntaje)
        {
            case 5:
                nivelDeDificultad = 1;
                break;

            case 10:
                nivelDeDificultad = 2;
                break;

        }
    }

    void AumentarDificultad ()
    {
        switch(nivelDeDificultad)
        {
            case 1:
                tiempoCaida = 0.4f;
                break;

            case 2:
                tiempoCaida = 0.2f;
                break;
        }
    }

}