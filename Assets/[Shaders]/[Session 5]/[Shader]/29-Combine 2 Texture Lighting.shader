
Shader "ShaderSuperb/Session5/29-Combine 2 Texture Lighting"
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
		Pass
		{
			Material
			{
				Diffuse[_DiffuseColor]
				Emission [_Emission]
			}
			Lighting On

			SetTexture[_MainTex]
			{
				ConstantColor [_Color]
				Combine constant * primary
			}

			SetTexture[_MainTex]
			{
				Combine texture * previous
			}
			
			SetTexture[_Textrue2]
			{
				Combine texture * previous
			}
		}
	}
}