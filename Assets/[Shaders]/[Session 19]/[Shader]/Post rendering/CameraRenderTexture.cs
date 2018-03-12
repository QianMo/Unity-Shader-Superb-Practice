using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 
[ExecuteInEditMode]
public class CameraRenderTexture : MonoBehaviour
{
    public Material Mat;
 
    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, Mat);
    }
}