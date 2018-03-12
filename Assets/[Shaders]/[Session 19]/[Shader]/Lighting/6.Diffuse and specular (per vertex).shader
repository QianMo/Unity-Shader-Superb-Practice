// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Diffuse and specular model calculated per vertex.

Shader "ShaderSuperb/Session19/Lighting/VertexSpecular"
{
	Properties
	{
		[Header(Diffuse)]
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Diffuse ("Value", Range(0, 1)) = 1.0
		
		[Header(Specular)]
		_SpecColor ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess ("Shininess", Range(0.1, 10)) = 1
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

			fixed4 _LightColor0;

			fixed4 _Color;
			fixed4 _SpecColor;
			
			float _Diffuse;
			float _Shininess;
			
			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);
				float3 refl = reflect(-lightDir, worldNormal);

				float NdotL = max(0.0, dot(worldNormal, lightDir));
				float RdotV = max(0.0, dot(refl, viewDir));
				
				fixed4 diff = _Color * NdotL * _LightColor0 * _Diffuse;
				fixed4 spec = ceil(NdotL) * _LightColor0 * _SpecColor * pow(RdotV, _Shininess);

				o.col = diff + spec;
				return o;
			}

			float4 frag(v2f i) : SV_Target {
				return i.col;
			}

			ENDCG
		}
	}
}