

Shader "ShaderSuperb/Session15/RGBA-Other/RGBA-15-Generate RGBA Pyarmid"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Generate_Pyramid_PosX_1("_Generate_Pyramid_PosX_1", Range(-1, 2)) = 0.5
		_Generate_Pyramid_PosY_1("_Generate_Pyramid_PosY_1", Range(-1, 2)) = 0.5
		_Generate_Pyramid_Size_1("_Generate_Pyramid_Size_1", Range(-1, 1)) = 0
		_Generate_Pyramid_Dist_1("_Generate_Pyramid_Dist_1", Range(0, 1)) = 1
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
			float _Generate_Pyramid_PosX_1;
			float _Generate_Pyramid_PosY_1;
			float _Generate_Pyramid_Size_1;
			float _Generate_Pyramid_Dist_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 Generate_Pyramid(float2 uv, float posX, float posY, float Size, float Smooth, float black, float Inverse)
			{
				uv = uv - float2(posX, posY);
				uv = abs(uv + uv);
				float dist = smoothstep(Size, Size + Smooth, fmod(max(uv.x, uv.y), 8.));
				dist = abs(dist - Inverse);
				float4 result = float4(1, 1, 1, dist);
				if (black == 1) result = float4(dist, dist, dist, 1);
				return result;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 _Generate_Pyramid_1 = Generate_Pyramid(i.texcoord,_Generate_Pyramid_PosX_1,_Generate_Pyramid_PosY_1,_Generate_Pyramid_Size_1,_Generate_Pyramid_Dist_1,0,0);
				float4 FinalResult = _Generate_Pyramid_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
