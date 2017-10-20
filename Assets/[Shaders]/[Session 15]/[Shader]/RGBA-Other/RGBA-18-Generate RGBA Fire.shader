
Shader "ShaderSuperb/Session15/RGBA-Other/RGBA-18-Generate RGBA Fire"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Generate_Fire_PosX_1("_Generate_Fire_PosX_1", Range(-1, 2)) = 0
		_Generate_Fire_PosY_1("_Generate_Fire_PosY_1", Range(-1, 2)) = 0
		_Generate_Fire_Precision_1("_Generate_Fire_Precision_1", Range(0, 1)) = 0.05
		_Generate_Fire_Smooth_1("_Generate_Fire_Smooth_1", Range(0, 1)) = 0.5
		_Generate_Fire_Speed_1("_Generate_Fire_Speed_1", Range(-2, 2)) = 1
		_SpriteFade("SpriteFade", Range(0, 1)) = 1.0

		// required for UI.Mask
		[HideInInspector]_StencilComp("Stencil Comparison", Float) = 8
		[HideInInspector]_Stencil("Stencil ID", Float) = 0
		[HideInInspector]_StencilOp("Stencil Operation", Float) = 0
		[HideInInspector]_StencilWriteMask("Stencil Write Mask", Float) = 255
		[HideInInspector]_StencilReadMask("Stencil Read Mask", Float) = 255
		[HideInInspector]_ColorMask("Color Mask", Float) = 15

	}

	SubShader
	{

		Tags {"Queue" = "Transparent" "IgnoreProjector" = "true" "RenderType" = "Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True"}
		ZWrite Off Blend SrcAlpha OneMinusSrcAlpha Cull Off

		// required for UI.Mask
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			struct appdata_t{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float2 texcoord  : TEXCOORD0;
				float4 vertex   : SV_POSITION;
				float4 color    : COLOR;
			};

			sampler2D _MainTex;
			float _SpriteFade;
			float _Generate_Fire_PosX_1;
			float _Generate_Fire_PosY_1;
			float _Generate_Fire_Precision_1;
			float _Generate_Fire_Smooth_1;
			float _Generate_Fire_Speed_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float Generate_Fire_hash2D(float2 x)
			{
				return frac(sin(dot(x, float2(13.454, 7.405)))*12.3043);
			}

			float Generate_Fire_voronoi2D(float2 uv, float precision)
			{
				float2 fl = floor(uv);
				float2 fr = frac(uv);
				float res = 1.0;
				for (int j = -1; j <= 1; j++)
				{
					for (int i = -1; i <= 1; i++)
					{
						float2 p = float2(i, j);
						float h = Generate_Fire_hash2D(fl + p);
						float2 vp = p - fr + h;
						float d = dot(vp, vp);
						res += 1.0 / pow(d, 8.0);
					}
				}
				return pow(1.0 / res, precision);
			}

			float4 Generate_Fire(float2 uv, float posX, float posY, float precision, float smooth, float speed, float black)
			{
				uv += float2(posX, posY);
				float t = _Time*60*speed;
				float up0 = Generate_Fire_voronoi2D(uv * float2(6.0, 4.0) + float2(0, -t), precision);
				float up1 = 0.5 + Generate_Fire_voronoi2D(uv * float2(6.0, 4.0) + float2(42, -t ) + 30.0, precision);
				float finalMask = up0 * up1  + (1.0 - uv.y);
				finalMask += (1.0 - uv.y)* 0.5;
				finalMask *= 0.7 - abs(uv.x - 0.5);
				float4 result = smoothstep(smooth, 0.95, finalMask);
				result.a = saturate(result.a + black);
				return result;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 _Generate_Fire_1 = Generate_Fire(i.texcoord,_Generate_Fire_PosX_1,_Generate_Fire_PosY_1,_Generate_Fire_Precision_1,_Generate_Fire_Smooth_1,_Generate_Fire_Speed_1,0);
				float4 FinalResult = _Generate_Fire_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
