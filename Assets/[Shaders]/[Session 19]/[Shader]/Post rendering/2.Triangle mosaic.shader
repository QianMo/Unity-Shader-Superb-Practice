// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderSuperb/Session19/Post renderingUnlit/TriangleMosaic"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TileNumX ("Tile number along X", float) = 30
		_TileNumY ("Tile number along Y", float) = 30
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 screenuv : TEXCOORD1;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.screenuv = ComputeScreenPos(o.pos);
				return o;
			}
			
			float _TileNumX;
			float _TileNumY;
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.screenuv.xy / i.screenuv.w;
				float2 TileNum = float2(_TileNumX, _TileNumY);
				float2 uv2 = floor(uv * TileNum) / TileNum;
				uv -= uv2;
				uv *= TileNum;

				fixed4 col = tex2D( _MainTex, uv2 + float2(step(1.0 - uv.y, uv.x) / (2.0 * _TileNumX),
				step(uv.x,uv.y)/(2.0 * _TileNumY)));

				return col;
			}
			ENDCG
		}
	}
}