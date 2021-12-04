using System.Collections;
using UnityEngine;

public class MainPlayerMovement : MonoBehaviour
{
    [SerializeField] private float speed;
    [SerializeField] private float rotationSpeed;
    [SerializeField] private float jumpSpeed;
    [SerializeField] private float jumpDelayTime;
    [SerializeField] private Transform cameraTransform;

    private CharacterController controller;
    private float ySpeed;
    private float originalStepOffset;
    private float? lastGroundTime;
    private float? jumpPressTime;
    private float horizontalInput;
    private float verticalInput;

    private MainPlayerData playerData;
    private GameObject SceneController;

    public bool isMoving;
    public bool onAir;
    public bool onWater;

    void Start()
    {
        controller = GetComponent<CharacterController>();
        originalStepOffset = controller.stepOffset;
        onAir = false;

        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<MainPlayerData>();

    }

    // Update is called once per frame
    void Update()
    {
        if (playerData.onDialog)
        {
            horizontalInput = 0.0f;
            verticalInput = 0.0f;
        }
        else
        {
            horizontalInput = Input.GetAxis("Horizontal");
            verticalInput = Input.GetAxis("Vertical");
        }

        Vector3 movementDirection = new Vector3(horizontalInput, 0, verticalInput);

        movementDirection = Quaternion.AngleAxis(cameraTransform.rotation.eulerAngles.y, Vector3.up) * movementDirection;

        float magnitude = Mathf.Clamp01(movementDirection.magnitude) * speed;
        movementDirection.Normalize();

        ySpeed += Physics.gravity.y * Time.deltaTime;

        if (controller.isGrounded)
        {
            lastGroundTime = Time.time;
            onAir = false;

        }

        if (Input.GetButtonDown("Jump"))
        {
            jumpPressTime = Time.time;
        }

        if (Time.time - lastGroundTime <= jumpDelayTime)
        {
            controller.stepOffset = originalStepOffset;
            ySpeed = -0.5f;

            if (Time.time - jumpPressTime <= jumpDelayTime)
            {
                ySpeed = jumpSpeed;
                onAir = true;
                jumpPressTime = null;
                lastGroundTime = null;

            }
        }
        else
        {
            controller.stepOffset = 0;
        }

        Vector3 velocity = movementDirection * magnitude;
        //velocity = AdjustVeloscityToSlope(velocity);
        velocity.y += ySpeed;

        controller.Move(velocity * Time.deltaTime);


        


        if (movementDirection != Vector3.zero)
        {
            Quaternion toRotation = Quaternion.LookRotation(movementDirection, Vector3.up);

            transform.rotation = Quaternion.RotateTowards(transform.rotation, toRotation, rotationSpeed * Time.deltaTime);

            isMoving = true;
        }
        else
        {
            isMoving = false;
        }


    }

    private void OnApplicationFocus(bool focus)
    {
        
        if (focus)
        {
            Cursor.lockState = CursorLockMode.Locked;
        }
        else
        {
            Cursor.lockState = CursorLockMode.None;
        }
    }

    private Vector3 AdjustVeloscityToSlope(Vector3 velocity)
    {
        var ray = new Ray(transform.position, Vector3.down);

        if (Physics.Raycast(ray, out RaycastHit hitInfo, 0.2f))
        {
            var slopeRotation = Quaternion.FromToRotation(Vector3.up, hitInfo.normal);
            var adjustedVelocity = slopeRotation * velocity;

            if (adjustedVelocity.y < 0)
            {
                return adjustedVelocity;
            }

        }

        return velocity;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Water")
        {
            onWater = true;

            Debug.Log(other.tag);

        }

    }


    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Water")
        {
            onWater = false;


        }

    }

}
