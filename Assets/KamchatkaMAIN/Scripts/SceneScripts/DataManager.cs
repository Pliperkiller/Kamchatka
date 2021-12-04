using UnityEngine.SceneManagement;
using UnityEngine;

public class DataManager : MonoBehaviour
{

    private string actualScene;
    private string previousScene;

    private string prefsLocation_x = "Ubicacion_x";
    private string prefsLocation_y = "Ubicacion_y";
    private string prefsLocation_z = "Ubicacion_z";


    private string prefsActualScene = "EscenaActual";
    private string prefsPreviousScene = "EscenaAnterior";
    private string prefsAnimalStatus = "EstadoAnimal";

    public int[] talismanes;
    public float[] location;


    private void Start()
    {
        loadData();
        actualScene = SceneManager.GetActiveScene().name;

    }


    private void OnDestroy()
    {

        saveData();


    }


    private void saveData()
    {
        PlayerPrefs.SetString(prefsPreviousScene, actualScene);


    }

    private void loadData()
    {

        previousScene = PlayerPrefs.GetString(prefsPreviousScene);
        Debug.Log(previousScene);


    }
}
