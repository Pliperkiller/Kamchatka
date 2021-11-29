using System.Collections;
using UnityEngine;
using TMPro;

public class DialogController : MonoBehaviour
{

    // Singleton
    public static DialogController singleton;

    [SerializeField] private GameObject dialogo;
    [SerializeField] private TextMeshProUGUI txtDialogo;
    [SerializeField] private float textSpeed;

    private bool dialogOn = false;
    private bool dialogRunning = false;

    private MainPlayerData playerData;
    private GameObject SceneController;

    [Header("Config de teclado")]
    public KeyCode teclaSiguienteFrase;
    public KeyCode teclaInicioDialogo;
    public KeyCode teclaSkipDialogo;



    private void Awake()
    {
        if (singleton == null)
        {
            singleton = this;
        }
        else
        {
            DestroyImmediate(gameObject);

        }
    }

    void Start()
    {
        dialogo.SetActive(false);

        teclaSkipDialogo = KeyCode.Ampersand;
        teclaSiguienteFrase = KeyCode.Ampersand;
        teclaInicioDialogo = KeyCode.F;

        SceneController = GameObject.Find("SceneController");
        playerData = SceneController.GetComponent<MainPlayerData>();

    }

    private void Update()
    {
        if (dialogOn)
        {
            if (dialogRunning)
            {
                teclaSkipDialogo = KeyCode.F;
                teclaSiguienteFrase = KeyCode.Ampersand;
                teclaInicioDialogo = KeyCode.Ampersand;
            }
            else
            {
                teclaSkipDialogo = KeyCode.Ampersand;
                teclaSiguienteFrase = KeyCode.F;
                teclaInicioDialogo = KeyCode.Ampersand;
            }

        }
        else
        {
            teclaSkipDialogo = KeyCode.Ampersand;
            teclaSiguienteFrase = KeyCode.Ampersand;
            teclaInicioDialogo = KeyCode.F;
        }

        playerData.onDialog = dialogOn;


    }

    public IEnumerator Decir(Frase[] _dialogo)
    {
        dialogo.SetActive(true);
        dialogOn = true;

        for (int i = 0; i < _dialogo.Length; i++)
        {
            
            for (int j = 0; j < _dialogo[i].texto.Length+1; j++)
            {

                dialogRunning = true;

                if (Input.GetKey(teclaSkipDialogo))
                {
                    j = _dialogo[i].texto.Length;
                    
                }
                yield return new WaitForSeconds(textSpeed);
                txtDialogo.text = _dialogo[i].texto.Substring(0, j);


            }
            dialogRunning = false;
            yield return new WaitForSeconds(0.5f);

            yield return new WaitUntil(() => Input.GetKeyUp(teclaSiguienteFrase));

        }
        dialogo.SetActive(false);
        dialogOn = false;

        

    }

}


[System.Serializable]
public class Frase
{
    public string texto;
}


[System.Serializable]
public class EstadoDialogo
{
    public Frase[] frases;
}