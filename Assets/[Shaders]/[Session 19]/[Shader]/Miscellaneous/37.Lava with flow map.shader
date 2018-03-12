// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Simulates a Lava movement with a flow map
// More information about Flow map :
// Flow map article http://graphicsrunner.blogspot.fr/2010/08/water-using-flow-maps.html


Shader "ShaderSuperb/Session19/Miscellaneous/Flow Map" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FlowMap ("Flow Map", 2D) = "grey" {}
		_Speed ("Speed", Range(-1, 1)) = 0.2
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
				fixed2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _FlowMap;
			fixed _Speed;

			fixed4 _MainTex_ST;

			v2f vert(appdata_base IN) {
				v2f o;
				o.pos = UnityObjectToClipPos(IN.vertex);
				o.uv = TRANSFORM_TEX(IN.texcoord, _MainTex);
				return o;
			}
		
			fixed4 frag(v2f v) : COLOR {
				fixed4 c;
				half3 flowVal = (tex2D(_FlowMap, v.uv) * 2 - 1) * _Speed;

				float dif1 = frac(_Time.y * 0.25 + 0.5);
				float dif2 = frac(_Time.y * 0.25);

				half lerpVal = abs((0.5 - dif1)/0.5);

				half4 col1 = tex2D(_MainTex, v.uv - flowVal.xy * dif1);
				half4 col2 = tex2D(_MainTex, v.uv - flowVal.xy * dif2);

				c = lerp(col1, col2, lerpVal);
				return c;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}