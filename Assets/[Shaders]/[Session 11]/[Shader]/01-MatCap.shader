//A bumped shader without lighting, for use with materials from programs like ZBrush.

//http://wiki.unity3d.com/index.php/MatCap
//reference:http://tsubakit1.hateblo.jp/entry/2016/06/30/073000
//http://tsubakit1.hateblo.jp/entry/2016/06/30/073000

//MatCap (Material Capture) shader, for displaying objects with reflective materials with uniform surface colouring, like Zbrush or Mudbox can. 
//It uses an image of a sphere as a view-space environment map. It's very cheap, and looks great when the camera doesn't rotate.


//get mapcap texture:https://www.pinterest.com/evayali/matcap/?lp=true

Shader "ShaderSuperb/Session11/01-MatCap"
{
	Properties {
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_BumpMap ("Bumpmap (RGB)", 2D) = "bump" {}
		_MatCap ("MatCap (RGB)", 2D) = "white" {}
	}
	
	Subshader {
		Tags { "RenderType"="Opaque" }
		Fog { Color [_AddFog] }
		
		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
			CGPROGRAM
				#pragma exclude_renderers xbox360
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"
				
				struct v2f { 
					float4 pos : SV_POSITION;
					float2	uv : TEXCOORD0;
					float3	TtoV0 : TEXCOORD1;
					float3	TtoV1 : TEXCOORD2;
				};
				
				uniform float4 _BumpMap_ST;
				
				v2f vert (appdata_tan v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos (v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord,_BumpMap);
					
					TANGENT_SPACE_ROTATION;
					o.TtoV0 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
					o.TtoV1 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
					return o;
				}
				
				uniform float4 _Color;
				uniform sampler2D _BumpMap;
				uniform sampler2D _MatCap;
				
				float4 frag (v2f i) : COLOR
				{
					float3 normal = UnpackNormal(tex2D(_BumpMap, i.uv));
					// normal = normalize(normal);
					
					half2 vn;
					vn.x = dot(i.TtoV0, normal);
					vn.y = dot(i.TtoV1, normal);
					
					float4 matcapLookup = tex2D(_MatCap, vn*0.5 + 0.5);
					
					matcapLookup.a = 1;
					
					return _Color*matcapLookup*2;
				}
			ENDCG
		}
	}
}

