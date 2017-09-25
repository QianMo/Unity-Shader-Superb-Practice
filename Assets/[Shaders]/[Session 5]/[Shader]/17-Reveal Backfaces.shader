//https://docs.unity3d.com/460/Documentation/Manual/SL-CullAndDepth.html

Shader "ShaderSuperb/Session5/17-Reveal Backfaces"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" { }
	}
	SubShader 
	{
		// Render the front-facing parts of the object.
		// We use a simple white material, and apply the main texture.
		Pass 
		{
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
			Color (0.1,0,0.1,1)
			Cull Front
		}
	}
}