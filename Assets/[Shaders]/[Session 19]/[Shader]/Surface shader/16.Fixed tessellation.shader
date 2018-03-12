Shader "ShaderSuperb/Session19/Surface shader/FixedTessellation" {
	Properties {
		_MainTex ("Main Texture (Diffuse)", 2D) = "white" {}
		_BumpTex ("Normal Map", 2D) = "bump" {}
		_DispTex ("Displacement Map", 2D) = "gray" {}
		_TexVal ("Tessellation value", Range(1,40)) = 1
		_DispVal ("Displacement factor", Range (0, 1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf BlinnPhong vertex:vert tessellate:tess
		#pragma target 4.6

		struct appdata {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 tangent : TANGENT;
			float2 texcoord : TEXCOORD0;
		};

		float _TexVal;

		float4 tess() {
			return _TexVal;
		}

		sampler2D _DispTex;
		float _DispVal;

		void vert(inout appdata v) {
			float val = tex2Dlod(_DispTex, float4(v.texcoord.xy, 0, 0)).r * _DispVal;
			v.vertex.xyz += v.normal * val;
		}

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_MainTex));
		}
		ENDCG
	} 
	FallBack "Diffuse"
}