// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Outlines a 3D model with 2 passes.
// Model from :
// Stick figure :https://free3d.com/3d-model/rigged-stick-figure-by-swp-2-55987.html

Shader "ShaderSuperb/Session19/Miscellaneous/Outline" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Outline ("_Outline", Range(0,0.1)) = 0
		_OutlineColor ("Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Pass {
			Tags { "RenderType"="Opaque" }
			Cull Front

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
			};

			float _Outline;
			float4 _OutlineColor;

			float4 vert(appdata_base v) : SV_POSITION {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				float3 normal = mul((float3x3) UNITY_MATRIX_MV, v.normal);
				normal.x *= UNITY_MATRIX_P[0][0];
				normal.y *= UNITY_MATRIX_P[1][1];
				o.pos.xy += normal.xy * _Outline;
				return o.pos;
			}

			half4 frag(v2f i) : COLOR {
				return _OutlineColor;
			}

			ENDCG
		}

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
		}

		ENDCG
	} 
	FallBack "Diffuse"
}