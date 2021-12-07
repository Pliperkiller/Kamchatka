using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogStarter : MonoBehaviour
{

    private int bandera;
    private string characterName;
    private bool playerIsNear;

    private MainPlayerData playerData;
    private GameObject SceneController;



    public int estadoActual;
    public EstadoDialogo[] estados;



    private void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<MainPlayerData>();

        bandera = 0;

        characterName = gameObject.name;

    }
    private void Update()
    {


        if (playerData.playerAnimalStatus != characterName)
        {
            estadoActual = 0;
        }
        else if (playerData.playerAnimalStatus == characterName && bandera == 0)
        {
            estadoActual = 1;

            if (playerData.onDialog)
            {
                bandera = 1;
            }

        }
        else if (playerData.playerAnimalStatus == characterName && bandera ==1)
        {
            estadoActual = 2;
            
        }



        if (playerIsNear)
        {

            if (Input.GetKeyUp(DialogController.singleton.teclaInicioDialogo))
            {
                StartCoroutine(DialogController.singleton.Decir(estados[estadoActual].frases));

            }


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
