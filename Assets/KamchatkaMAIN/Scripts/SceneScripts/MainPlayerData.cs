using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainPlayerData : MonoBehaviour
{

    public string playerAnimalStatus;
    public bool BearPiece;
    public bool MonkeyPiece;
    public bool SquirrelPiece;
    public bool OtterPiece;
    public bool onDialog;

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
