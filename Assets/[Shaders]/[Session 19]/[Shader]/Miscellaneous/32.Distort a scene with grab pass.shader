// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Distort a model through a plane with a grab pass.
// Model comes from :
// Armchair :https://free3d.com/3d-model/armchair-39723.html

Shader "ShaderSuperb/Session19/Miscellaneous/DistortingGrabPass" {
	Properties {
		_Intensity ("Intensity", Range(0, 50)) = 0
	}
	SubShader {
		GrabPass { "_GrabTexture" }

		Pass {
			Tags { "Queue"="Transparent" }
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				half4 pos : SV_POSITION;
				half4 grabPos : TEXCOORD0;
			};

			sampler2D _GrabTexture;
			half _Intensity;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				return o;
			}

			half4 frag(v2f i) : COLOR {
				i.grabPos.x += sin((_Time.y + i.grabPos.y) * _Intensity)/20;
				fixed4 color = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabPos));
				return color;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}