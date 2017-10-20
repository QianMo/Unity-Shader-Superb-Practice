
Shader "ShaderSuperb/Session15/RGBA-Other/RGBA-07-Premade Gradients"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
		_PremadeGradients_Offset_1("_PremadeGradients_Offset_1", Range(-1, 1)) =0
		_PremadeGradients_Fade_1("_PremadeGradients_Fade_1", Range(0, 1)) =1
		_PremadeGradients_Speed_1("_PremadeGradients_Speed_1", Range(-2, 2)) =0
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
			sampler2D _NewTex_1;
			float _PremadeGradients_Offset_1;
			float _PremadeGradients_Fade_1;
			float _PremadeGradients_Speed_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 Color_PreGradients(float4 rgba, float4 a, float4 b, float4 c, float4 d, float offset, float fade, float speed)
			{
				float gray = (rgba.r + rgba.g + rgba.b) / 3;
				gray += offset+(speed*_Time*20);
				float4 result = a + b * cos(6.28318 * (c * gray + d));
				result.a = rgba.a;
				result.rgb = lerp(rgba.rgb, result.rgb, fade);
				return result;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 NewTex_1 = tex2D(_NewTex_1, i.texcoord);
				float4 _PremadeGradients_1 = Color_PreGradients(NewTex_1,float4(0.5,0.5,0.5,1),float4(0.5,0.5,0.5,1),float4(0.8,0.8,0.8,1),float4(0,0.33,0.67,1),_PremadeGradients_Offset_1,_PremadeGradients_Fade_1,_PremadeGradients_Speed_1);
				float4 FinalResult = _PremadeGradients_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
