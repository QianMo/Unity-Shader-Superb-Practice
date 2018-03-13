Shader "ShaderSuperb/Session21/Reflective/Fresnel/Cook-Torrance Bumped Specular" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_RMS("BDF RMS (Specular spread)",Range(0.001,1)) = 0.707
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_Fresnel("Reflection Fresnel Exponent",Range(0,6)) = 1
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_Cube ("Reflection Cubemap", Cube) = "_Skybox" { TexGen CubeReflect }
	}

	SubShader 
	{ 
		Tags { "RenderType"="Opaque" }
		LOD 600
		
		CGPROGRAM
		#include "CgHelper.cginc"
		#pragma surface surf CookTorrance fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;
		half _Shininess;
		float _RMS;
		samplerCUBE _Cube;
		fixed4 _ReflectColor;
		half _Fresnel;

		inline float BDist(float3 N,float3 H,float m)
		{
			float alpha = acos(dot(N,H));
			float caq = pow(cos(alpha),2);
			float simp = (1-caq)/(caq*m*m);
			float kspec = exp(-simp)/(PI*m*m*caq*caq);
			return kspec;
		}

		inline float Schlick(float Rzero,float3 lightDir,float3 normal)
		{
			return Rzero + (1 - Rzero)*pow((1 - dot(lightDir,normal)),5);
		}
		
		inline float Schlick2(float Rzero,float3 lightDir,float3 normal,float exponent)
		{
			return Rzero + (1 - Rzero)*pow((1 - dot(lightDir,normal)),exponent);
		}

		inline fixed4 LightingCookTorrance (SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			float3 h = normalize (lightDir + viewDir);
			float hn = dot(h,s.Normal);
			float vh = dot(viewDir,h);
			float G = max(0,min(1,min((2*hn*dot(viewDir,s.Normal))/vh,(2*hn*dot(lightDir,s.Normal))/vh)));
			float diff = max (0, dot (s.Normal, lightDir));
			float spec = min(1,max(0,BDist(s.Normal,h,(_RMS))*Schlick(1-s.Specular,h,s.Normal)*s.Gloss/(dot(viewDir,s.Normal))));
			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb*diff + _LightColor0.rgb * _SpecColor.rgb*spec) * (G*atten*2);
			c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * G*atten;
			return c;
		}

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = tex.rgb * _Color.rgb;
			o.Gloss = tex.a;
			o.Alpha = tex.a * _Color.a;
			o.Specular = _Shininess;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			float3 worldRefl = WorldReflectionVector (IN, o.Normal);
			fixed4 reflcol = texCUBE (_Cube, worldRefl);
			reflcol *= tex.a;
			reflcol *= Schlick2(0,normalize(IN.viewDir),o.Normal,_Fresnel);
			o.Emission = reflcol.rgb * _ReflectColor.rgb;
		}
		ENDCG
	}

	FallBack "Reflective/Bumped Specular"
}
