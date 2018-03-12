// Draw a texture like if it were a wireframe model

Shader "ShaderSuperb/Session19/Surface shader/WireFrame" {
	Properties {
		_LineColor ("LineColor", Color) = (1, 1, 1, 1)
		_MainColor ("_MainColor", Color) = (1, 1, 1, 1)
		_LineWidth ("Line width", Range(0, 1)) = 0.1
		_ParcelSize ("ParcelSize", Range(0, 100)) = 1
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		
		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		float4 _LineColor;
		float4 _MainColor;
		fixed _LineWidth;
		float _ParcelSize;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half val1 = step(_LineWidth * 2, frac(IN.worldPos.x / _ParcelSize) + _LineWidth);
			half val2 = step(_LineWidth * 2, frac(IN.worldPos.z / _ParcelSize) + _LineWidth);
			fixed val = 1 - (val1 * val2);
			o.Albedo = lerp(_MainColor, _LineColor, val);
			o.Alpha = 1;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}