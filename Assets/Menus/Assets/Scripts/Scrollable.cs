using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class Scrollable : MonoBehaviour
{
    [SerializeField]
    RawImage ScrollableImage;
    [SerializeField]
    float ScrollSpeed;
    [SerializeField]
    Vector2 ScrollDirection;
    Rect rect;
    // Start is called before the first frame update
    void Start()
    {
        rect = ScrollableImage.uvRect;
    }

    // Update is called once per frame
    void Update()
    {
        rect.x += ScrollDirection.x*ScrollSpeed*Time.deltaTime;
        rect.y += ScrollDirection.y * ScrollSpeed * Time.deltaTime;
        ScrollableImage.uvRect = rect;
    }
}
