
Shader "ShaderSuperb/Session6/06-Silhouette"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}

		_DotProduct("Rim effect", Range(-1,1)) = 0.25
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		LOD 200

		Cull Off

		CGPROGRAM
		#pragma surface surf Lambert alpha:fade 

		sampler2D _MainTex;
		fixed4 _Color;

		float _DotProduct;

		struct Input 
		{
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		//void surf(Input IN, inout SurfaceOutputStandard o) {
		void surf(Input IN, inout SurfaceOutput o) 
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			float alpha = (border * (1 - _DotProduct) + _DotProduct);
			o.Alpha = c.a * alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
