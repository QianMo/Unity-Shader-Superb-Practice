
Shader "ShaderSuperb/Session6/08-CustomLambertLighting"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma surface surf CustomLambert 

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		half4 LightingCustomLambert(SurfaceOutput s, half3 lightDir, half atten) 
		{
			half NdotL = dot(s.Normal, lightDir);
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 1);
			c.a = s.Alpha;
			return c;
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}



		ENDCG
	}
	Fallback "Diffuse"
}
