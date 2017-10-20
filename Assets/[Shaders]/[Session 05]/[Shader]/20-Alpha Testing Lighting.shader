//https://docs.unity3d.com/460/Documentation/Manual/SL-AlphaTest.html

Shader "ShaderSuperb/Session5/20-Alpha Testing Lighting"
{
	Properties
	{
		_MainTex ("Base (RGB) Transparency (A)", 2D) = "" {}
		_Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
		_Color ("Main Color", Color) = (.5, .5, .5, .5)
	}
	SubShader 
	{
		Pass 
		{
			// Only render pixels with an alpha larger than 50%
			AlphaTest Greater [_Cutoff]

			Lighting On
			
			Material 
			{
				Diffuse [_Color]
				Ambient [_Color]
			}

			SetTexture [_MainTex] { combine texture * previous }
		}
	}
}