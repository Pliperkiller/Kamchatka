using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OtterAnimationController : MonoBehaviour
{
    private Animator animator;

    private MainPlayerMovement movement;
    private GameObject playerHolder;


    void Start()
    {
        playerHolder = GameObject.Find("PlayerHolder");
        movement = playerHolder.GetComponent<MainPlayerMovement>();

        animator = GetComponent<Animator>();
    }

    void Update()
    {
        animator.SetBool("IsMoving", movement.isMoving);
        animator.SetBool("OnAir", movement.onAir);
        animator.SetBool("OnWater", movement.onWater);


    }

    

}
