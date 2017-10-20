
Shader "ShaderSuperb/Session5/31-Combine 2 Texture Lighting Specular Alpha"
{
	Properties 
	{
		_Color("Main color",Color) = (0.6,0.6,0.6,1)
		_DiffuseColor("Diffuse color",Color) = (0.6,0.6,0.6,1)
		_Emission("Emission",Color) = (0.6,0.6,0.6,1)
		_Shininess ("Shininess Color", Range(0,5)) = 0.6
		_SpecColor ("SpecColor Color", Color) = (1,0.5,0.5,1)
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
				Shininess [_Shininess]
				Specular [_SpecColor]
				Emission [_Emission]
			}
			Lighting On
			SeparateSpecular On

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