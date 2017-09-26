
Shader "ShaderSuperb/Session5/32-Combine 3 Texture"
{
	Properties 
	{
		_Color("Main color",Color) = (0.6,0.6,0.6,1)
		_MainTex ("Base Texture (RGB)", 2D) = "white" {}
		_Textrue2 ("Texture 2(RGB)", 2D) = "white" {}
		_Textrue3 ("Texture 3(RGB)", 2D) = "white" {}
	}

	SubShader 
	{
		Pass
		{
			SetTexture[_MainTex]
			{
				Combine texture * primary
			}
			
			SetTexture[_Textrue2]
			{
				Combine texture * previous
			}
			
			SetTexture[_Textrue3]
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