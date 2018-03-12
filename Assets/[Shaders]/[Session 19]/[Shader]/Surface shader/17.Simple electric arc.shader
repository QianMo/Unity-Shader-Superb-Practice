// Move a texture like it were a electric arc.
// Be careful : This shader is old and a lame, don't use it. ;)


Shader "ShaderSuperb/Session19/Surface shader/ElectricArc" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_NoiseTex ("Noise Texture", 2D) = "grey" {}
		_Speed ("Speed", Range(0, 50)) = 1
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		
		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		sampler2D _NoiseTex;
		float _Speed;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NoiseTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float time1 = frac(ceil(_Time.y * _Speed) * 0.01);
			float time2 = frac(ceil(_Time.x * _Speed) * 0.01);
			float noise = tex2D(_NoiseTex, float2(time1, time2)).r;
			float2 uv = IN.uv_MainTex;
			uv.y = frac(uv.y + noise);
			half4 color = tex2D (_MainTex, uv);
			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}