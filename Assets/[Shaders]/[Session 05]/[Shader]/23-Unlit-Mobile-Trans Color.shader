
Shader "ShaderSuperb/Session5/23-Unlit-Mobile-Trans Color"
{
	Properties 
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1) 
	}

	SubShader 
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100

		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha 

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