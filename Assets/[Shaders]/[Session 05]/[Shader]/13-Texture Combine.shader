//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/13-Texture Combine"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "grey" { }
	}

	SubShader 
	{

		Pass
		{
			//光照 打开/关闭
			Lighting Off
			
			SetTexture [_MainTex] 
			{
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
