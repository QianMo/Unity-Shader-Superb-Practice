//https://docs.unity3d.com/Manual/SL-SetTexture.html

Shader "ShaderSuperb/Session5/14-Texture Combine V2"
{
	Properties 
	{
		_Color("Main Color",Color) = (0.6,0.6,0.6,1)
		_MainTex ("Base (RGB)", 2D) = "grey" { }
	}

	SubShader 
	{

		Pass
		{
			//光照 打开/关闭
			Lighting Off

			// Use texture alpha to blend up to white (= full illumination)
			SetTexture [_MainTex] 
			{
				constantColor [_Color]
				combine constant * previous
			}

			// Multiply in texture
			SetTexture [_MainTex] 
			{
				//https://docs.unity3d.com/Manual/SL-SetTexture.html
				//combine src1 * src2
				//combine src1 + src2
				//combine src1 - src2
				//combine src1 lerp (src2) src3
				//combine src1 * src2 + src3
				combine previous - texture
			}
		}
	}
	Fallback "Diffuse"
}
