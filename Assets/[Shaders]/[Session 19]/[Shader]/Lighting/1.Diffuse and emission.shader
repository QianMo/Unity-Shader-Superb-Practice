// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Lighting with diffuse and emission parameters.

Shader "ShaderSuperb/Session19/Lighting/Emission"
{
	Properties
	{
		[Header(Diffuse)]
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Diffuse ("Diffuse value", Range(0, 1)) = 1.0
		[Header(Emission)]
		_MainTex ("Emissive Map", 2D) = "white" {}
		[HDR] _EmissionColor ("Emission Color", Color) = (0,0,0)
		_Threshold ("Threshold", Range(0., 1.)) = 1.
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

			struct v2f 
			{
				float4 pos : SV_POSITION;
				fixed4 col : COLOR0;
				float2 uv : TEXCOORD0;
			};

			fixed4 _Color;
			fixed4 _LightColor0;
			float _Diffuse;
			
			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_base v) 
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float NdotL = max(0.0, dot(worldNormal, lightDir));
				fixed4 diff = _Color * NdotL * _LightColor0 * _Diffuse;
				o.col = diff;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float4 _EmissionColor;
			float _Threshold;

			fixed4 frag(v2f i) : SV_Target 
			{
				fixed3 emi = tex2D(_MainTex, i.uv).r * _EmissionColor.rgb * _Threshold;
				i.col.rgb += emi;
				return i.col;
			}

			ENDCG
		}
	}
}