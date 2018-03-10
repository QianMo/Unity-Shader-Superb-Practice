// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Particle Dissolve/Softrim/Opacity/Alpha Blended" 
{
Properties {
	_MainTex ("Particle Texture", 2D) = "white" {}
	_Opacity ("Opacity", Range (0,1)) = 1
	_Rim ("Soft Edge", Range (0,1)) = 1
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	//Blend One One
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off Lighting Off ZWrite Off
	
	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			
			struct appdata_t {
				fixed4 vertex : POSITION;
				fixed4 color : COLOR;
				fixed2 texcoord : TEXCOORD0;
				fixed3 normal : NORMAL;
			};

			struct v2f {
				fixed4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				fixed2 texcoord : TEXCOORD0;
			};
			
			fixed4 _MainTex_ST;
			fixed _Opacity;
			fixed _Rim;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				fixed3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				
				//viewDir.x = -abs(viewDir.x);
				//viewDir.y = abs(viewDir.y);
				//viewDir.z = abs(viewDir.z);
				viewDir.x = 1;
				viewDir.y = 1;
				viewDir.z = 1;				
				
				
				//v.normal.x = -abs(v.normal.x);
				//v.normal.y = -abs(v.normal.y);
				//v.normal.z = abs(v.normal.z);
				v.normal.x = 0;
				v.normal.y = -abs(v.normal.y);
				v.normal.z = 1;
				
				fixed dotProduct = dot(v.normal, viewDir);
				o.color.rgb = v.color.rgb;
				o.color.a = smoothstep(1 - _Rim, 1.0, dotProduct)*v.color.a;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord);
				return fixed4(tex.rgb*i.color.rgb,tex.a*step(1-i.color.a,tex.a)*_Opacity);
			}
			ENDCG 
		}
	}	
}
}
