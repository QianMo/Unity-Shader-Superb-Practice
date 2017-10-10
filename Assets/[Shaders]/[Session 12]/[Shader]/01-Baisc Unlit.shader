

Shader "ShaderSuperb/Session12/01-Baisc Unlit"
{
	Properties 
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
	}


	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Back Lighting Off ZWrite On
		Pass 
		{
			SetTexture [_MainTex] 
			{
				constantColor [_TintColor]
				Combine texture *  constant DOUBLE, texture * constant
			}
		}
	}
}

