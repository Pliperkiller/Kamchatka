using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyDisplacement1 : MonoBehaviour
{
    private GameObject Player;
    public float speed = 5.0f ;
    public float angleoffset;
    private Vector3 Direction;
    private Vector3 Velocity;
    private float angle;


    // Start is called before the first frame update
    void Start()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
    }

    // Update is called once per frame
    void Update()
    {
        Direction = (Player.transform.position - transform.position)/(Vector3.Distance(Player.transform.position,transform.position));
        angle = -Mathf.Atan2(Direction.z , Direction.x)*Mathf.Rad2Deg;

        //Debug.Log(Direction.x);

        transform.position = Vector3.MoveTowards(transform.position,Player.transform.position,speed*Time.deltaTime);
        transform.rotation = Quaternion.Euler(new Vector3(0, angle + angleoffset, 0));
    }
}
