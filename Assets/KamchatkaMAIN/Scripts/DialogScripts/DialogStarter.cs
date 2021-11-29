using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogStarter : MonoBehaviour
{
    [SerializeField] private GameObject chat;
    [SerializeField] private GameObject action;

    private MainPlayerData playerData;
    private GameObject SceneController;
    private int bandera;


    public int estadoActual;
    public EstadoDialogo[] estados;
    // Start is called before the first frame update

    private bool playerIsNear;

    private void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<MainPlayerData>();

        action.SetActive(false);

        bandera = 0;

    }
    private void Update()
    {
        Debug.Log(bandera);

        if (playerData.playerAnimalStatus != "Monkey")
        {
            estadoActual = 0;
        }
        else if (playerData.playerAnimalStatus == "Monkey" && bandera == 0)
        {
            estadoActual = 1;

            if (playerData.onDialog)
            {
                bandera = 1;
            }

        }
        else if (playerData.playerAnimalStatus == "Monkey" && bandera ==1)
        {
            estadoActual = 2;
            
        }



        if (playerIsNear)
        {
            chat.SetActive(!playerData.onDialog);
            action.SetActive(!playerData.onDialog);

            if (Input.GetKeyUp(DialogController.singleton.teclaInicioDialogo))
            {
                StartCoroutine(DialogController.singleton.Decir(estados[estadoActual].frases));

            }

            if (playerData.playerAnimalStatus != "Monkey")
            {
                action.SetActive(true);

            }
            else
            {
                action.SetActive(false);
            }



        }
        else
        {
            action.SetActive(false);
            chat.SetActive(false);

        }




    }
    public void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            playerIsNear = true;


        }




    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            playerIsNear = false;
        }





    }
}
