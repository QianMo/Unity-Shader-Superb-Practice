// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Lambert diffuse model calculated per vertex.

Shader "ShaderSuperb/Session19/Lighting/VertexLambertDiffuse"
{
	Properties
	{
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Diffuse ("Diffuse value", Range(0, 1)) = 1.0
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed4 col : COLOR0;
			};

			fixed4 _Color;
			fixed4 _LightColor0;
			float _Diffuse;

			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float NdotL = max(0.0, dot(worldNormal, lightDir));
				fixed4 diff = _Color * NdotL * _LightColor0 * _Diffuse;
				o.col = diff;
				return o;
			}

			float4 frag(v2f i) : SV_Target {
				return i.col;
			}

			ENDCG
		}
	}
}