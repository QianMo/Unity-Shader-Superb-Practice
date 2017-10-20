
Shader "ShaderSuperb/Session5/22-Unlit-Mobile-Texture Color"
{
	Properties 
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1) 
	}

	SubShader 
	{
		Tags {"RenderType"="Opaque"}
		LOD 100

		ZWrite On

		Pass 
		{
			Lighting Off
			SetTexture [_MainTex] 
			{
				constantColor [_Color]

				Combine texture * constant, texture * constant 
			} 
		}
	}
}