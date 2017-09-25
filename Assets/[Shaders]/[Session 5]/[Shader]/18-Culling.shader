//https://docs.unity3d.com/460/Documentation/Manual/SL-CullAndDepth.html

Shader "ShaderSuperb/Session5/18-Culling"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,0)
		_SpecColor ("Spec Color", Color) = (1,1,1,1)
		_Emission ("Emmisive Color", Color) = (0,0,0,0)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.7
		_MainTex ("Base (RGB)", 2D) = "white" { }
	}

	SubShader 
	{
		// We use the material in many passes by defining them in the subshader.
		// Anything defined here becomes default values for all contained passes.
		Material 
		{
			Diffuse [_Color]
			Ambient [_Color]
			Shininess [_Shininess]
			Specular [_SpecColor]
			Emission [_Emission]
		}
		Lighting On
		SeparateSpecular On

		// Set up alpha blending
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend One One

		// Render the back facing parts of the object.
		// If the object is convex, these will always be further away
		// than the front-faces.
		Pass 
		{
			Cull Front
			SetTexture [_MainTex] 
			{
				Combine Primary * Texture
			}
		}
		// Render the parts of the object facing us.
		// If the object is convex, these will be closer than the
		// back-faces.
		Pass 
		{
			Cull Back
			SetTexture [_MainTex] 
			{
				Combine Primary * Texture
			}
		}
	}
}