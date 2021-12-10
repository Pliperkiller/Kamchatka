using UnityEngine.SceneManagement;
using UnityEngine;

public class DataManager : MonoBehaviour
{

    private string actualScene;
    private string previousScene;




    private string prefsActualScene = "EscenaActual";
    private string prefsPreviousScene = "EscenaAnterior";
    private string prefsAnimalStatus = "EstadoAnimal";



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
