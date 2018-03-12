// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Use trigonometric functions to animate a flag
// Flag comes from :
// http://tf3dm.com/3d-model/flags-of-countries-80363.html

Shader "ShaderSuperb/Session19/Miscellaneous/Flag" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Speed ("Speed", Range(0, 5.0)) = 1
		_Frequency ("Frequency", Range(0, 1.3)) = 1
		_Amplitude ("Amplitude", Range(0, 5.0)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		Cull off
		
		Pass {

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float _Speed;
			float _Frequency;
			float _Amplitude;

			v2f vert(appdata_base v)
			{
				v2f o;
				v.vertex.y +=  cos((v.vertex.x + _Time.y * _Speed) * _Frequency) * _Amplitude * (v.vertex.x - 5);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}

			ENDCG

		}
	}
	FallBack "Diffuse"
}