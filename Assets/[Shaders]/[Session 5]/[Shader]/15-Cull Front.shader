//https://docs.unity3d.com/460/Documentation/Manual/SL-CullAndDepth.html

Shader "ShaderSuperb/Session5/15-Cull Front"
{
	SubShader 
	{
		Pass 
		{
			Material 
			{
				Diffuse (1,1,1,1)
				Emission (0.5,0.5,0.5,1)
			}
			Lighting On
			Cull Front
		}
	}
}
