// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Try to look like an old VHS Tape
// Shader source :
// https://pastebin.com/mb8YjuTq
 
// Script :
// https://pastebin.com/vE65NE30
 
// Video comes from :
// http://www.beachfrontbroll.com/p/animal-stock-video.html
// Textures :
// http://www.shaderslab.com/images/tvnoise2.jpg?crc=4021489216



Shader "ShaderSuperb/Session19/Post rendering/VHSeffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondaryTex ("Secondary Texture", 2D) = "white" {}
		_OffsetNoiseX ("Offset Noise X", float) = 0.0
		_OffsetNoiseY ("Offset Noise Y", float) = 0.0
		_OffsetPosY ("Offset position Y", float) = 0.0
		_OffsetColor ("Offset Color", Range(0.005, 0.1)) = 0.03
		_OffsetDistortion ("Offset Distortion", float) = 500
		_Intensity ("Mask Intensity", Range(0.0, 1)) = 1.0
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

			half _OffsetNoiseX;
			half _OffsetNoiseY;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.uv2 = v.texcoord + float2(_OffsetNoiseX - 0.2f, _OffsetNoiseY);
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _SecondaryTex;

			fixed _Intensity;
			float _OffsetColor;
			half _OffsetPosY;
			half _OffsetDistortion;

			fixed4 frag (v2f i) : SV_Target
			{
				i.uv = float2(frac(i.uv.x + cos((i.uv.y + _CosTime.y) * 100) / _OffsetDistortion), frac(i.uv.y + _OffsetPosY));
				
				fixed4 col = tex2D(_MainTex, i.uv);
			    col.g = tex2D(_MainTex, i.uv + float2(_OffsetColor, _OffsetColor)).g;
				col.b = tex2D(_MainTex, i.uv + float2(-_OffsetColor, -_OffsetColor)).b;

				fixed4 col2 = tex2D(_SecondaryTex, i.uv2);

				return lerp(col, col2, ceil(col2.r - _Intensity)) * (1 - ceil(saturate(abs(i.uv.y - 0.5) - 0.49)));
			}
			ENDCG
		}
	}
}