using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyPlayerPos : MonoBehaviour
{
    Material Mat;
    GameObject Player;
    public int Radius = 10;
 
    void Start()
    {
        // Get the material
        Mat = GetComponent<Renderer>().material;
        // Get the player object
        Player = GameObject.Find("Player");
    }
 
    void Update()
    {
        // Set the player position in the shader file
        Mat.SetVector("_PlayerPos", Player.transform.position);
        // Set the distance or radius
        Mat.SetFloat("_Dist", Radius);
    }
}
