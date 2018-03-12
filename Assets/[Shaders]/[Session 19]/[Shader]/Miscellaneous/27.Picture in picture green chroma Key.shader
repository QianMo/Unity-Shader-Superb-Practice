// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// To mix two textures with green chroma Key.
// Texture :
// Squirrel :http://7428.net/2014/04/cartoon-squirrel-design-vector.html


Shader "ShaderSuperb/Session19/Miscellaneous/PictureInPicture" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SecondaryTex ("Secondary Texture", 2D) = "white" {}
		_GreenThreshold ("GreenThreshold", Range(0, 1.0)) = 0
		_BlueThreshold ("BlueThreshold", Range(0, 1.0)) = 0
		_RedThreshold ("RedThreshold", Range(0, 1.0)) = 0
	}
	SubShader {
		Pass {
			Tags { "RenderType"="Opaque" }
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SecondaryTex;
			float4 _SecondaryTex_ST;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv1 = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv2 = TRANSFORM_TEX(v.texcoord, _SecondaryTex);
				return o;
			}

			float _GreenThreshold;
			float _BlueThreshold;
			float _RedThreshold;
			
			fixed4 frag(v2f i) : COLOR {
				fixed4 col1 = tex2D(_MainTex, i.uv1);
				fixed4 col2 = tex2D(_SecondaryTex, i.uv2);
				fixed val = floor(1 - saturate(col1.r - _RedThreshold))
				* floor(1 - saturate(col1.b - _BlueThreshold))
				* saturate(col1.g + _GreenThreshold);
				return lerp(col1, col2, val);
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}