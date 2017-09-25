//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/03-Base Fixed Function Texture"
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
			
			SetTexture [_MainTex] {}
		}
	}
	Fallback "Diffuse"
}
