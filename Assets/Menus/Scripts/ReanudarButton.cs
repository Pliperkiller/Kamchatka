using UnityEngine;
using UnityEngine.SceneManagement;


public class ReanudarButton : MonoBehaviour
{


    public void ReanudarPlayButton()
    {
        Time.timeScale = 1;
        if (SceneManager.GetActiveScene().name== "GrisslyTrouble")
        {
            Cursor.lockState = CursorLockMode.None;

        }
        else
        {
            Cursor.lockState = CursorLockMode.Locked;


        }





    }
}
