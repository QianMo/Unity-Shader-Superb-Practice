// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Dissolves a paper like if it were burning.


Shader "ShaderSuperb/Session19/Miscellaneous/BurningPaper"
{
	Properties {
		_MainTex ("Main texture", 2D) = "white" {}
		_DissolveTex ("Dissolution texture", 2D) = "gray" {}
		_Threshold ("Threshold", Range(0, 1.1)) = 0
	}

	SubShader {

		Tags { "Queue"="Geometry" }

		Pass {
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			sampler2D _DissolveTex;
			float _Threshold;

			fixed4 frag(v2f i) : SV_Target {
				fixed4 c = tex2D(_MainTex, i.uv);
				fixed val = 1 - tex2D(_DissolveTex, i.uv).r;
				if(val < _Threshold - 0.04)
				{
					discard;
				}

				bool b = val < _Threshold;
				return lerp(c, c * fixed4(lerp(1, 0, 1 - saturate(abs(_Threshold - val) / 0.04)), 0, 0, 1), b);
			}

			ENDCG

		}

	}
	FallBack "Diffuse"
}