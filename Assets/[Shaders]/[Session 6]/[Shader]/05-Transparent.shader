
Shader "ShaderSuperb/Session6/05-Transparent"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}

	SubShader 
	{
		// Transparent (ordering)
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		// Removes back geometry
		//Cull Off

		CGPROGRAM
		//【to Transparent，add alpha:fade】 Alpha blending
		#pragma surface surf Standard alpha:fade

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input 
		{
			float2 uv_MainTex;
		};


		void surf(Input IN, inout SurfaceOutputStandard o) 
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
