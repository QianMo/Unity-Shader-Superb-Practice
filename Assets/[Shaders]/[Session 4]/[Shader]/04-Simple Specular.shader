//https://docs.unity3d.com/Manual/SL-SurfaceShaderLightingExamples.html

Shader "ShaderSuperb/Session3/04-Simple Specular"
{
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf SimpleSpecular

		half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) 
		{
			half3 h = normalize (lightDir + viewDir);

			half diff = max (0, dot (s.Normal, lightDir));

			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, 48.0);

			half4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
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
