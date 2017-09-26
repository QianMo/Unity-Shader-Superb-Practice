
Shader "ShaderSuperb/Session5/30-Combine 2 Texture Lighting Alpha"
{
	Properties 
	{
		_Color("Main color",Color) = (0.6,0.6,0.6,1)
		_DiffuseColor("Diffuse color",Color) = (0.6,0.6,0.6,1)
		_Emission("Emission",Color) = (0.6,0.6,0.6,1)
		_MainTex ("Base Texture (RGB)", 2D) = "white" {}
		_Textrue2 ("Texture 2(RGB)", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "Queue" = "Transparent" }
		Pass
		{
			Material
			{
				Diffuse[_DiffuseColor]
				Ambient[_DiffuseColor]
				Emission [_Emission]
			}
			Lighting On
			Blend One OneMinusDstColor          // Soft Additive

			SetTexture[_MainTex]
			{
				Combine texture * primary
			}
			
			SetTexture[_Textrue2]
			{
				Combine texture * previous
			}

			SetTexture[_MainTex]
			{
				ConstantColor [_Color]
				Combine previous * constant
			}
		}
	}
}