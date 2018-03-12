// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Turns the green color to transparency.
//http://www.shaderslab.com/demo-91---green-chromakey-to-transparency.html

Shader "ShaderSuperb/Session19/Miscellaneous/GreenToTransparent"
{
	Properties {
		_MainTex ("Base", 2D) = "white" {}
		_Threshold ("Threshold", Range(0, 1)) = 0
	}
	SubShader {
		Pass {
			Tags { "Queue"="Transparent" "RenderType"="Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv1 : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv1 = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float _Threshold;
			
			fixed4 frag(v2f i) : COLOR {
				fixed4 col1 = tex2D(_MainTex, i.uv1);
				fixed4 val = ceil(saturate(col1.g - col1.r - _Threshold)) * ceil(saturate(col1.g - col1.b - _Threshold));
				return lerp(col1, fixed4(0., 0., 0., 0.), val);
			}

			ENDCG
		}
	} 
}