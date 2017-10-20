//https://docs.unity3d.com/460/Documentation/Manual/SL-AlphaTest.html

Shader "ShaderSuperb/Session5/21-Alpha Testing For Vegetation"
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

			//Lighting On

			Material 
			{
				Diffuse [_Color]
				//Ambient (1,1,1,1)
			}	

			SetTexture [_MainTex] 
			{
				combine texture * primary, texture
				//combine texture * previous 
			}
		}

		// Second pass:
		// render in the semitransparent details.
		Pass 
		{
			// Dont write to the depth buffer
			ZWrite off
			// Don't write pixels we have already written.
			ZTest Less
			// Only render pixels less or equal to the value
			AlphaTest LEqual [_Cutoff]

			// Set up alpha blending
			Blend SrcAlpha OneMinusSrcAlpha

			SetTexture [_MainTex] 
			{
				combine texture * primary, texture
			}
		}

	}
}