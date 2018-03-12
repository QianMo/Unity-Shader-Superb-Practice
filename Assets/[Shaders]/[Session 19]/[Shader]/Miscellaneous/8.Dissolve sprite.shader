// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//Dissolves a sprite with a texture.
// Warning : it doesn't work well with spritesheet
// Sprite comes :
// OpenGameArt

Shader "ShaderSuperb/Session19/Miscellaneous/2D/Dissolve"
{
	Properties {
		[PerRendererData] _MainTex ("Main texture", 2D) = "white" {}
		_DissolveTex ("Dissolution texture", 2D) = "gray" {}
		_Threshold ("Threshold", Range(0., 1.01)) = 0.
	}

	SubShader {

		Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

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

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			sampler2D _DissolveTex;
			float _Threshold;

			fixed4 frag(v2f i) : SV_Target {
				float4 c = tex2D(_MainTex, i.uv);
				float val = tex2D(_DissolveTex, i.uv).r;

				c.a *= step(_Threshold, val);
				return c;
			}
			ENDCG
		}
	}
}