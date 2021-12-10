
using UnityEngine;

public class Generador : MonoBehaviour
{
    [SerializeField] private GameObject[] tetrominos;

    [SerializeField] AudioClip fijarFichaClip;

    private AudioSource audioSource;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();

        NuevoTetromino();

    }

    void Update()
    {

    }

    public void NuevoTetromino()
    {
        audioSource.PlayOneShot(fijarFichaClip, 1f);
        Instantiate(tetrominos[Random.Range(0, tetrominos.Length)], transform.position, Quaternion.identity);

    }
}
