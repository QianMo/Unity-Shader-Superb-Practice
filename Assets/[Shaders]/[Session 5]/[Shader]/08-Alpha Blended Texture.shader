//https://docs.unity3d.com/Manual/SL-SetTexture.html

Shader "ShaderSuperb/Session5/08-Alpha Blended Texture"
{

	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendTex ("Alpha Blended (RGBA) ", 2D) = "white" {}
	}

	SubShader 
	{
		Pass 
		{
			// 应用基础纹理
			SetTexture [_MainTex] 
			{
				combine texture
			}
			// 使用 lerp 操作符混合 alpha 纹理
			SetTexture [_BlendTex] 
			{
				// combine src1 lerp (src2) src3
				// Interpolates between src3 and src1, 
				// using the alpha of src2. Note that the interpolation is opposite direction:
				// src1 is used when alpha is one, and src3 is used when alpha is zero.
				combine texture lerp (texture) previous
			}
		}
	}
	Fallback "Diffuse"
}
