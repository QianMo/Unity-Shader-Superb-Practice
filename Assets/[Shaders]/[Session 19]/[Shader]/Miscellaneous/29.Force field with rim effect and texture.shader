// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//Simulates a force field with a sphere, rim effect and a texture.

Shader "ShaderSuperb/Session19/Miscellaneous/Shield" {
	Properties {
		_MainTex ("Texture", 2D ) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_RimEffect ("Rim effect", Range(0, 1)) = 0
	}
	SubShader {
		Pass {
			Tags { "Queue"="Transparent" "RenderType"="Transparent" }
			Blend One One
			Cull Off
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_full v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal.xyz));
				o.viewDir = normalize(_WorldSpaceCameraPos - mul((float3x3)unity_ObjectToWorld, v.vertex.xyz));
				o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
				return o;
			}

			fixed4 _Color;
			fixed _RimEffect;

			fixed4 frag(v2f i) : COLOR {
				float t = tex2D(_MainTex, i.uv);
				float val = 1 - abs(dot(i.viewDir, i.normal)) * _RimEffect;
				return _Color * _Color.a * val * val * t;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}