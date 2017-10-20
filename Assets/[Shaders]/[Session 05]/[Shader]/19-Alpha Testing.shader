//https://docs.unity3d.com/460/Documentation/Manual/SL-AlphaTest.html

Shader "ShaderSuperb/Session5/19-Alpha Testing"
{
	Properties
	{
		_MainTex ("Base (RGB) Transparency (A)", 2D) = "" {}
		_Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
	}
	SubShader 
	{
		Pass 
		{
			// Only render pixels with an alpha larger than 50%
			AlphaTest Greater [_Cutoff]
			SetTexture [_MainTex] { combine texture }
		}
	}
}