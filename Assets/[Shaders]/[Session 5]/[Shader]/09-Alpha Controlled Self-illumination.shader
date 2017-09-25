//https://docs.unity3d.com/Manual/SL-SetTexture.html

Shader "ShaderSuperb/Session5/09-Alpha Controlled Self-illumination"
{
	Properties 
	{
		_MainTex ("Base (RGB) Self-Illumination (A)", 2D) = "white" {}
		_Color ("Main Color" , Color) = (0.6,0.6,0.6,1)
	}

	SubShader 
	{
		Pass 
		{
			Lighting Off

			// Use texture alpha to blend up to white (= full illumination)
			SetTexture [_MainTex] 
			{
				//constantColor (0.5,0.5,1,1)
				// Pull the color property into this blender
				constantColor [_Color]
				// combine src1 lerp (src2) src3
				// Interpolates between src3 and src1, 
				// using the alpha of src2. Note that the interpolation is opposite direction:
				// src1 is used when alpha is one, and src3 is used when alpha is zero.
				combine constant lerp(texture) texture
			}

			// Multiply in texture
			SetTexture [_MainTex] 
			{
				combine previous * texture
			}
		}
	}
	Fallback "Diffuse"
}
