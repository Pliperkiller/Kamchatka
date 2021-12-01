using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrisslyAnimation : MonoBehaviour
{
    private Animator animator;

    private GrisslyCharacterController movement;
    private GameObject playerHolder;

    // Start is called before the first frame update
    void Start()
    {
        playerHolder = GameObject.Find("PlayerHolder");
        movement = playerHolder.GetComponent<GrisslyCharacterController>();

        animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        animator.SetBool("IsMoving", movement.isMoving);
        animator.SetBool("Attack", Input.GetMouseButtonDown(0));

        if (Input.GetMouseButtonDown(0))
        {
            Debug.Log("Attack");
        }



    }
}
