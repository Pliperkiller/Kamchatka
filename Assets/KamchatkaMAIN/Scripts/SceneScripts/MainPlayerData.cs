using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainPlayerData : MonoBehaviour
{

    public string playerAnimalStatus;
    public bool northPiece;
    public bool southPiece;
    public bool eastPiece;
    public bool westhPiece;
    public Transform playerLocation;

    void Start()
    {
        playerAnimalStatus = "Default";

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
