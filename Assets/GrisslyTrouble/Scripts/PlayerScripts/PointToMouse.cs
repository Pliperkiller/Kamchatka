using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PointToMouse : MonoBehaviour
{
    public float angleoffset;
    private Vector3 Mousepos;
    private Vector3 Objectpos;
    private float angle;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Mousepos = Input.mousePosition;
        Objectpos = Camera.main.WorldToScreenPoint(transform.position);

        float xpos = Mousepos.x - Objectpos.x;
        float ypos = Mousepos.y - Objectpos.y;

        angle = -Mathf.Atan2(ypos, xpos) * Mathf.Rad2Deg;
        transform.rotation = Quaternion.Euler(new Vector3(0, angle + angleoffset, 0));

    }
}
