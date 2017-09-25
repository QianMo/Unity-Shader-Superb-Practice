//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/04-Fixed Function Light Texture"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "grey" { }
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

			SetTexture [_MainTex] 
			{
				//https://docs.unity3d.com/Manual/SL-SetTexture.html
				//Combine ColorPart, AlphaPart
				Combine texture * primary
				//Combine texture * primary DOUBLE, texture * primary
			}
		}
	}
	Fallback "Diffuse"
}
