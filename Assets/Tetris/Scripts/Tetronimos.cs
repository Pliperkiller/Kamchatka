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

    private float t1 = 0;
    private float t2 = 0;

    private GameObject sceneManager;
    private TetrisPlayerData playerData;



    void Start()
    {

        sceneManager = GameObject.FindWithTag("GameController");
        playerData = sceneManager.GetComponent<TetrisPlayerData>();

    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            MoveLeft();

        }
        else if (Input.GetKey(KeyCode.A))
        {
            t1 += Time.deltaTime;

            if (t1 >= 0.1f)
            {
                MoveLeft();
                t1 = 0;
            }


        }
        else
        {
            t1 = 0f;
        }


        if (Input.GetKeyDown(KeyCode.D))
        {
            MoveRight();

        }
        else if (Input.GetKey(KeyCode.D))
        {
            t2 += Time.deltaTime;

            if (t2 >= 0.1f)
            {
                MoveRight();
                t2 = 0;
            }

        }
        else
        {
            t2 = 0f;
        }

        if(playerData.playerStatus == "NAN")
        {
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

        }
        

        if (Input.GetKeyDown(KeyCode.W))
        {
            transform.RotateAround(transform.TransformPoint(puntoRotation), new Vector3(0,0,1), -90);
            if (!Limites())
            {
                transform.RotateAround(transform.TransformPoint(puntoRotation), new Vector3(0, 0, 1), 90);
            }
        }


        
    }

    private void MoveLeft()
    {
        transform.position += new Vector3(-1, 0, 0);
        if (!Limites())
        {
            transform.position -= new Vector3(-1, 0, 0);
        }

    }

    private void MoveRight()
    {
        transform.position += new Vector3(1, 0, 0);
        if (!Limites())
        {
            transform.position -= new Vector3(1, 0, 0);
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

                playerData.playerStatus = "Lose";
                
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
        playerData.score = puntaje;

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

   

}
