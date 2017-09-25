//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/02-Fixed Function Lighting Specular"
{
	Properties 
	{
		_DiffuseColor ("Diffuse Color", Color) = (1,0.5,0.5,1)
		_AmbientColor ("Ambient Color", Color) = (1,0.5,0.5,1)
		_Shininess ("Shininess Color", Range(0,5)) = 0.6
		_SpecColor ("SpecColor Color", Color) = (1,0.5,0.5,1)
		_Emission ("Emission Color", Color) = (1,0.5,0.5,1)
	}

	SubShader 
	{
		Pass
		{
			//光照 打开/关闭
			Lighting On
			//镜面高光开关 打开/关闭
			SeparateSpecular On
			
			Material
			{
				Diffuse [_DiffuseColor]
				Ambient [_AmbientColor]
				Shininess [_Shininess]
				Specular [_SpecColor]
				Emission [_Emission]
			}
		}
	}
	Fallback "Diffuse"
}
