
Shader "ShaderSuperb/Session15/RGBA-Other/RGBA-16-Generate RGBA Shape"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Generate_Shape_PosX_1("_Generate_Shape_PosX_1", Range(-1, 2)) = 0.5
		_Generate_Shape_PosY_1("_Generate_Shape_PosY_1", Range(-1, 2)) = 0.5
		_Generate_Shape_Size_1("_Generate_Shape_Size_1", Range(-1, 1)) = 0.4
		_Generate_Shape_Dist_1("_Generate_Shape_Dist_1", Range(0, 1)) = 0.01
		_Generate_Shape_Side_1("_Generate_Shape_Side_1", Range(1, 32)) = 3
		_Generate_Shape_Rotation_1("_Generate_Shape_Rotation_1", Range(-360, 360)) = 0
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
			float _Generate_Shape_PosX_1;
			float _Generate_Shape_PosY_1;
			float _Generate_Shape_Size_1;
			float _Generate_Shape_Dist_1;
			float _Generate_Shape_Side_1;
			float _Generate_Shape_Rotation_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 Generate_Shape(float2 uv, float posX, float posY, float Size, float Smooth, float number, float black, float rot)
			{
				uv = uv - float2(posX, posY);
				float angle = rot * 0.01744444;
				float a = atan2(uv.x, uv.y) +angle, r = 6.28318530718 / int(number);
				float d = cos(floor(0.5 + a / r) * r - a) * length(uv);
				float dist = 1.0 - smoothstep(Size, Size + Smooth, d);
				float4 result = float4(1, 1, 1, dist);
				if (black == 1) result = float4(dist, dist, dist, 1);
				return result;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 _Generate_Shape_1 = Generate_Shape(i.texcoord,_Generate_Shape_PosX_1,_Generate_Shape_PosY_1,_Generate_Shape_Size_1,_Generate_Shape_Dist_1,_Generate_Shape_Side_1,0,_Generate_Shape_Rotation_1);
				float4 FinalResult = _Generate_Shape_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
