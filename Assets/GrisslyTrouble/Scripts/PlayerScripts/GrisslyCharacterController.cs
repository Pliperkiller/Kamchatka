using UnityEngine;

public class GrisslyCharacterController : MonoBehaviour
{
    private float velocity;
    private Vector3 VelVector;
    private float h;
    private float v;
    public float extraHoney = 0.0f;
    public bool isMoving = false;

    private Rigidbody rb;
    private GrisslyPlayerData PlayerData;
    private GameObject SceneController;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        SceneController = GameObject.Find("SceneController");
        PlayerData = SceneController.GetComponent<GrisslyPlayerData>();

        velocity = 5.0f;
    }


    void Update()
    {
        h = Input.GetAxisRaw("Horizontal");
        v = Input.GetAxisRaw("Vertical");



        if (h != 0 && v != 0)
        {
            
            VelVector = new Vector3(h * velocity/1.4142f, 0, v * velocity / 1.4142f);
            isMoving = true;

        }

        else if(h!=0 || v != 0)
        {
            VelVector = new Vector3(h * velocity, 0, v * velocity);
            isMoving = true;

        }
        else
        {
            VelVector = new Vector3(0, 0, 0);
            isMoving = false;

        }

        rb.velocity = VelVector;

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Item")
        {
            if (PlayerData.honeyAmount>10)
            {
                extraHoney++;

                velocity = 30 - 25 * Mathf.Exp(-0.005f * extraHoney);
               

            }
            
        }
    }

}
