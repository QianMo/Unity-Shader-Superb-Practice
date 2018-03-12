// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// The texture changes depending the lighting's intensity.
// Based on :
// Wiki article :https://en.wikibooks.org/wiki/Cg_Programming/Unity/Layers_of_Textures


Shader "ShaderSuperb/Session19/Miscellaneous/TextureDependingLight"
{
	Properties
	{
		_MainTex ("Texture in Light", 2D) = "white" {}
		_SecondaryTex ("Texture in shadow", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "LightMode" = "ForwardBase" }
		Pass {

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float light : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _SecondaryTex;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				float3 worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				o.light = max(0, dot(worldNormal, lightDir));
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed4 col1 = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_SecondaryTex, i.uv);
				return lerp(col2, col1, i.light);
			}

			ENDCG
		}
	}
}