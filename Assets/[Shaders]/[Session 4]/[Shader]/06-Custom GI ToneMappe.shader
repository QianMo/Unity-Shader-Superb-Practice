//https://docs.unity3d.com/Manual/SL-SurfaceShaderLightingExamples.html

Shader "ShaderSuperb/Session3/06-Custom GI ToneMappe"
{
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Gain("Lightmap tone-mapping Gain", Float) = 1
		_Knee("Lightmap tone-mapping Knee", Float) = 0.5
		_Compress("Lightmap tone-mapping Compress", Float) = 0.33
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM

		#pragma surface surf StandardToneMappedGI

		#include "UnityPBSLighting.cginc"

		half _Gain;
		half _Knee;
		half _Compress;
		sampler2D _MainTex;

		inline half3 TonemapLight(half3 i) 
		{
			i *= _Gain;
			return (i > _Knee) ? (((i - _Knee)*_Compress) + _Knee) : i;
		}

		inline half4 LightingStandardToneMappedGI(SurfaceOutputStandard s, half3 viewDir, UnityGI gi)
		{
			return LightingStandard(s, viewDir, gi);
		}

		inline void LightingStandardToneMappedGI_GI(
			SurfaceOutputStandard s,
			UnityGIInput data,
			inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);

			gi.light.color = TonemapLight(gi.light.color);
			#ifdef DIRLIGHTMAP_SEPARATE
				#ifdef LIGHTMAP_ON
					gi.light2.color = TonemapLight(gi.light2.color);
				#endif
				#ifdef DYNAMICLIGHTMAP_ON
					gi.light3.color = TonemapLight(gi.light3.color);
				#endif
			#endif
			gi.indirect.diffuse = TonemapLight(gi.indirect.diffuse);
			gi.indirect.specular = TonemapLight(gi.indirect.specular);
		}

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard  o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex);
		}

		ENDCG
	}
	Fallback "Diffuse"
}
