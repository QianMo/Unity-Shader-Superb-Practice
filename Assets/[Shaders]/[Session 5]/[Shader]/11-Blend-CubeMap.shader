//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/11-Blend-CubeMap"
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
			//进行纹理混合  
			Blend One One

			//设置材质  
			Material
			{  
				Diffuse [_Color]  
			}  

			//开光照  
			Lighting On  

			//和纹理相乘  
			SetTexture [_Reflections]   
			{  
				combine previous * texture quad
				//Matrix [_Reflection]
			}  
		}  
	}
	Fallback "Diffuse"
}
