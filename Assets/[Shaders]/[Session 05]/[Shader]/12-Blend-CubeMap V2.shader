//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/12-Blend-CubeMap V2"
{

	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)  
		_MainTex ("Base (RGB) Transparency (A)", 2D) = "white" {}  
		_Reflections ("Base (RGB) Gloss (A)", Cube) = "skybox" {  }  
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		Pass   
        {  
            Blend SrcAlpha OneMinusSrcAlpha  
  
            Material   
            {  
                Diffuse [_Color]  
            }  
  
            Lighting On  
            SetTexture [_MainTex] 
            {  
                combine texture * primary double, texture * primary
            }  
        } 

	}
	Fallback "Diffuse"
}
