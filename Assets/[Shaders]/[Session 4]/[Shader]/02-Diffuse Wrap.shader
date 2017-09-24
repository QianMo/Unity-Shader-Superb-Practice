//https://docs.unity3d.com/Manual/SL-SurfaceShaderLightingExamples.html

//The following example shows Wrapped Diffuse, a modification of Diffuse lighting where illumination “wraps around” the edges of objects. 
//It’s useful for simulating subsurface scattering effects.

Shader "ShaderSuperb/Session3/02-Diffuse Wrap"
{
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf WrapLambert

		half4 LightingWrapLambert (SurfaceOutput s, half3 lightDir, half atten) 
		{
			half NdotL = dot (s.Normal, lightDir);
			half diff = NdotL * 0.5 + 0.5;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten);
			c.a = s.Alpha;
			return c;
		}

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
