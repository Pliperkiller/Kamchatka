using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interact : MonoBehaviour
{
    private GameObject chat;
    private GameObject action;
    private GameObject actionBox;
    private MainPlayerData playerData;
    private GameObject SceneController;

    private string targetName;
    private bool nearTarget;

    void Start()
    {
        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<MainPlayerData>();
        targetName = gameObject.name;

        actionBox = GameObject.Find("ActionBox");
        action = actionBox.transform.GetChild(0).gameObject;
        chat = actionBox.transform.GetChild(1).gameObject;


        action.SetActive(false);
    }

    void Update()
    {

        if (nearTarget)
        {
            if (playerData.onDialog)
            {
                chat.SetActive(false);

            }
            else
            {
                chat.SetActive(true);
            }

            if (targetName != playerData.playerAnimalStatus)
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
            chat.SetActive(false);
            action.SetActive(false);
        }



    }

    private void OnTriggerStay(Collider other)
    {
        

        if(other.tag == "NPC")
        {
            nearTarget = true;

            targetName = other.name;


        }
        else
        {
            nearTarget = false;


        }


    }
}
