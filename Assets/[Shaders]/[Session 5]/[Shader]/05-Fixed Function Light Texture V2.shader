//https://docs.unity3d.com/Manual/ShaderTut1.html

Shader "ShaderSuperb/Session5/05-Fixed Function Light Texture V2"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "grey" { }
		_MainColor ("Main Color", Color) = (1,0.5,0.5,1)
		_AmbientColor ("Ambient Color", Color) = (1,0.5,0.5,1)
		_Shininess ("Shininess Color", Range(0,5)) = 0.6
		_SpecColor ("SpecColor Color", Color) = (1,0.5,0.5,1)
		_Emission ("Emission Color", Color) = (1,0.5,0.5,1)
	}

	SubShader 
	{
		//Tags{  "LightMode" = "ForwardBase"  "Queue"="Transparent" "IngnoreProjector"="True" "RenderType"="Transparent" }
		Pass
		{
			//光照 打开/关闭
			Lighting On
			//镜面高光开关 打开/关闭
			SeparateSpecular On

			Material
			{
				Diffuse [_MainColor]
				Ambient [_AmbientColor]
				Shininess [_Shininess]
				Specular [_SpecColor]
				Emission [_Emission]
			}

			SetTexture [_MainTex] 
			{
				constantColor [_MainColor]
				Combine texture * primary DOUBLE, texture * constant
			}
		}
	}
	Fallback "Diffuse"
}
