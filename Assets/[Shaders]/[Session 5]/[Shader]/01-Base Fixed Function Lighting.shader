//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/01-Base Fixed Function Lighting"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,0.5,0.5,1)
	}

	SubShader 
	{

		Pass
		{
			//光照 打开/关闭
			Lighting On
			
			Material
			{
				Diffuse[_Color]
			}
		}
	}
	Fallback "Diffuse"
}
