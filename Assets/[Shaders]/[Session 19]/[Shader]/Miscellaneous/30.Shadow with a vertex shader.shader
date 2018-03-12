// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//How to produce shadows with vertex functions.

Shader "ShaderSuperb/Session19/Miscellaneous/VertexShadow" {
	Properties 
		{
			_Color ("Color", Color) = (1, 1, 1, 1)
		}
	SubShader {
		Pass {
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase 

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				LIGHTING_COORDS(0, 1)
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				return o;
			}

			fixed4 _Color;
			fixed4 _LightColor0;

			fixed4 frag(v2f i) : COLOR {
				float attenuation = LIGHT_ATTENUATION(i);
				return _Color * attenuation * _LightColor0;
			}

			ENDCG
		}
	}
    
	Fallback "VertexLit"
}