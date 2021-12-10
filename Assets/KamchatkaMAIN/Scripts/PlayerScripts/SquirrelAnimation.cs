using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SquirrelAnimation : MonoBehaviour
{
    private Animator animator;

    private MainPlayerMovement movement;
    private GameObject playerHolder;

    // Start is called before the first frame update
    void Start()
    {
        playerHolder = GameObject.Find("PlayerHolder");
        movement = playerHolder.GetComponent<MainPlayerMovement>();

        animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        animator.SetBool("IsMoving", movement.isMoving);



    }
}
