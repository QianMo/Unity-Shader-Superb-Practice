
// Post rendering effect that disturbs the color channels.
// Camera script :
// https://pastebin.com/MkaniGUa

Shader "ShaderSuperb/Session19/Post rendering/Chromatic aberration"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}

		[Header(Red)]
		_RedX ("Offset X", Range(-0.5, 0.5)) = 0.1
		_RedY ("Offset Y", Range(-0.5, 0.5)) = -0.22

		[Header(Green)]
		_GreenX ("Offset X", Range(-0.5, 0.5)) = 0.05
		_GreenY ("Offset Y", Range(-0.5, 0.5)) = -0.2

		[Header(Blue)]
		_BlueX ("Offset X", Range(-0.5, 0.5)) = 0.12
		_BlueY ("Offset Y", Range(-0.5, 0.5)) = -0.15
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _RedX;
			float _RedY;
			float _GreenX;
			float _GreenY;
			float _BlueX;
			float _BlueY;
			
			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 col = fixed4(1, 1, 1, 1);

				float2 red_uv = i.uv + float2(_RedX, _RedY);
				float2 green_uv = i.uv + float2(_GreenX, _GreenY);
				float2 blue_uv = i.uv + float2(_BlueX, _BlueY);

				col.r = tex2D(_MainTex, red_uv).r;
				col.g = tex2D(_MainTex, green_uv).g;
				col.b = tex2D(_MainTex, blue_uv).b;

				return col;
			}
			ENDCG
		}
	}
}