// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// Add a noise just before the frame is rendered.
// Shader source :
// https://pastebin.com/WX8EiM3y
 
// Camera script :
// https://pastebin.com/3hfngmDf
 
// Video come from :
// http://www.beachfrontbroll.com/p/animal-stock-video.html

Shader "ShaderSuperb/Session19/Post rendering/PostRenderNoise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondaryTex ("Secondary Texture", 2D) = "white" {}
		_OffsetX ("OffsetX", float) = 0.2
		_OffsetY ("OffsetY", float) = 0.1
		_Intensity ("Mask Intensity", Range(0, 1)) = 0.9
		_Color ("Color", Color) = (1.0, 0.0, 0.0, 1.0)
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			half _OffsetX;
			half _OffsetY;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.uv2 = v.texcoord + float2(_OffsetX, _OffsetY);
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _SecondaryTex;
			fixed4 _Color;
			fixed _Intensity;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_SecondaryTex, i.uv2);
				return lerp(col, _Color, ceil(saturate(1 - col2.r - _Intensity)));
			}
			ENDCG
		}
	}
}