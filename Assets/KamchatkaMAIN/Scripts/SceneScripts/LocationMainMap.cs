
using UnityEngine;

public class LocationMainMap : MonoBehaviour
{
    public float x_location;
    public float y_location;
    public float z_location;
    private string prefsLocation_x = "Ubicacion_x";
    private string prefsLocation_y = "Ubicacion_y";
    private string prefsLocation_z = "Ubicacion_z";


    private void Awake()
    {
        loadData();
    }

    private void Start()
    {
        Debug.Log(new Vector3(x_location, y_location + 0.1f, z_location));

        gameObject.transform.position = new Vector3(x_location, y_location + 0.1f, z_location);

    }



    private void OnDestroy()
    {
        saveData();
    }

    private void saveData()
    {
        x_location = gameObject.transform.position.x;
        y_location = gameObject.transform.position.y;
        z_location = gameObject.transform.position.z;

        PlayerPrefs.SetFloat(prefsLocation_x, x_location);
        PlayerPrefs.SetFloat(prefsLocation_y, y_location);
        PlayerPrefs.SetFloat(prefsLocation_z, z_location);

        Debug.Log(gameObject.transform.position);



    }

    private void loadData()
    {
        x_location = PlayerPrefs.GetFloat(prefsLocation_x);
        y_location = PlayerPrefs.GetFloat(prefsLocation_y);
        z_location = PlayerPrefs.GetFloat(prefsLocation_z);  

    }
}
