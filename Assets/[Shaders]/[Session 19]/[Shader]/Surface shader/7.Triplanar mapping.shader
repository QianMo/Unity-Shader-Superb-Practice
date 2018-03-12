//To Apply and mix three different textures by considering the normals.

Shader "ShaderSuperb/Session19/Surface shader/Triplanar" {
	Properties {
		_Texture1 ("Texture 1", 2D) = "white" {}
		_Texture2 ("Texture 2", 2D) = "white" {}
		_Texture3 ("Texture 3", 2D) = "white" {}
		_Scale ("Scale", Range(0.001, 0.2)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Standard

		sampler2D _Texture1;
		sampler2D _Texture2;
		sampler2D _Texture3;
		float _Scale;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			fixed4 col1 = tex2D(_Texture2, IN.worldPos.yz * _Scale);
			fixed4 col2 = tex2D(_Texture1, IN.worldPos.xz * _Scale);
			fixed4 col3 = tex2D(_Texture3, IN.worldPos.xy * _Scale);

			float3 vec = abs(IN.worldNormal);
			vec /= vec.x + vec.y + vec.z + 0.001f;
			fixed4 col = vec.x * col1 + vec.y * col2 + vec.z * col3;

			o.Albedo = col;
			o.Emission = col;
		}

		ENDCG
	}
	FallBack "Diffuse"
}