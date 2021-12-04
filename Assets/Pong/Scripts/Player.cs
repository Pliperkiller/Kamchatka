using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum ePlayer
{
    Left,
    Right
}

public class Player : MonoBehaviour
{

    [SerializeField] private float speed = 15f;
    public ePlayer player;


    void Update()
    {
        float inputSpeed = 0;
        if (player == ePlayer.Left)
        {
           inputSpeed = Input.GetAxisRaw("Vertical");
        }
        else if (player == ePlayer.Right)
        {
            inputSpeed = Input.GetAxisRaw("Vertical");
        }

        transform.position += new Vector3(0f, 0f, inputSpeed * speed * Time.deltaTime);
        
    }
}
