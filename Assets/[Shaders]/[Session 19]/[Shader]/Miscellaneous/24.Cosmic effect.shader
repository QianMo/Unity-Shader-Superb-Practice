// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// The model looks like the galaxy were in itself.
// Model comes from :
// http://tf3dm.com/3d-model/rigged-stick-figure-by-swp-2-55987.html


Shader "ShaderSuperb/Session19/Miscellaneous/CosmicEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Zoom ("Zoom", Range(0.5, 20)) = 1
		_Speed ("Speed", Range(0.01, 10)) = 1
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 vert (appdata_base v) : SV_POSITION
			{
				return UnityObjectToClipPos(v.vertex);
			}
			
			sampler2D _MainTex;
			half _Zoom;
			half _Speed;

			fixed4 frag (float4 i : VPOS) : SV_Target
			{
				return tex2D(_MainTex, float2((i.xy/ _ScreenParams.xy) + float2(_CosTime.x * _Speed, _SinTime.x * _Speed) / _Zoom));
			}
			ENDCG
		}
	}
}