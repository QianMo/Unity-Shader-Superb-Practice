//Discard the faces that are not front of the camera.

Shader "ShaderSuperb/Session19/Miscellaneous/FrontFaces"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_ScalarVal ("Value", Range(0.0, 1.0)) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				fixed val : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half _ScalarVal;

			v2f vert(appdata_base v) {
				v2f o;
				float4 worldpos = mul(unity_ObjectToWorld, v.vertex);
				o.pos = mul(UNITY_MATRIX_VP, worldpos);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				float3 worldnormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				
				if(dot(worldnormal, normalize(_WorldSpaceCameraPos.xyz - worldpos.xyz)) > _ScalarVal)
					o.val = 1;
				else
					o.val = 0;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				if(i.val < 0.99) discard;
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}

			ENDCG
		}
	}
}