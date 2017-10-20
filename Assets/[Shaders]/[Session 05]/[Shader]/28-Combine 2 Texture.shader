
Shader "ShaderSuperb/Session5/28-Combine 2 Texture"
{
	Properties 
	{
		_Color("Main color",Color) = (0.6,0.6,0.6,1)
		_MainTex ("Base Texture (RGB)", 2D) = "white" {}
		_Textrue2 ("Texture 2(RGB)", 2D) = "white" {}
	}

	SubShader 
	{
		Pass
		{
			Lighting Off

			SetTexture[_MainTex]
			{
				ConstantColor [_Color]
				Combine constant * texture
			}
			
			SetTexture[_Textrue2]
			{
				Combine texture * previous
			}
		}
	}
}