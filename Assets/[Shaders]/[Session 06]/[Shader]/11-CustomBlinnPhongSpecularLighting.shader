
Shader "ShaderSuperb/Session6/11-CustomBlinnPhongSpecularLighting"
{
	Properties
	{
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0.1,60)) = 3
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"}
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong nofog

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecPower;

		half4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float NdotL = max(0,dot(s.Normal, lightDir));
			float3 halfVector = normalize(lightDir + viewDir);
			float NdotH = max(0, dot(s.Normal, halfVector));
			float spec = pow(NdotH, _SpecPower) * _SpecularColor;
			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb *
			_SpecularColor.rgb * spec) * atten;
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
