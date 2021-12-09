
using UnityEngine;

public class BeeKillSound : MonoBehaviour
{
    [SerializeField] AudioClip deadBeeClip;

    private AudioSource audioSource;

    private float timer = 0;

    private void Awake()
    {
        audioSource = GetComponent<AudioSource>();

        audioSource.PlayOneShot(deadBeeClip, 1f);

    }


    private void Update()
    {
        timer += Time.deltaTime;

        if (timer > 1)
        {
            Destroy(gameObject);

        }

    }

}
