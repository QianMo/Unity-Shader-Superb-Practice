//https://docs.unity3d.com/460/Documentation/Manual/SL-CullAndDepth.html

Shader "ShaderSuperb/Session5/17-Reveal Backfaces"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" { }
		//反面的颜色
		_innerColor("Inner Color",Color)=(0.6,0.6,0.6,1)
	}
	SubShader 
	{
		// Render the front-facing parts of the object.
		// We use a simple white material, and apply the main texture.
		Pass 
		{
			Cull Back
			Material 
			{
				Diffuse (1,1,1,1)
				Emission (0.5,0.5,0.5,1)
			}

			Lighting On

			SetTexture [_MainTex] 
			{
				Combine Primary * Texture
			}
		}

		// Now we render the back-facing triangles in the most
		// irritating color in the world: BRIGHT PINK!
		Pass 
		{
			Color [_innerColor]
			Cull Front
		}
	}
}