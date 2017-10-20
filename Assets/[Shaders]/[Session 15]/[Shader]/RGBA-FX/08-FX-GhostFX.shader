
Shader "ShaderSuperb/Session15/RGBA-FX/08-FX-GhostFX"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
		_GhostFX_Smooth_1("_GhostFX_Smooth_1", Range(0, 1)) = 0.442683
		_GhostFX_ClipUp_1("_GhostFX_ClipUp_1", Range(0, 1)) = 0.8390243
		_GhostFX_ClipDown_1("_GhostFX_ClipDown_1", Range(0, 1)) = 0.7439025
		_GhostFX_ClipLeft_1("_GhostFX_ClipLeft_1", Range(0, 1)) = 0.5682924
		_GhostFX_ClipRight_1("_GhostFX_ClipRight_1", Range(0, 1)) = 0.612195
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
			float _GhostFX_Smooth_1;
			float _GhostFX_ClipUp_1;
			float _GhostFX_ClipDown_1;
			float _GhostFX_ClipLeft_1;
			float _GhostFX_ClipRight_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 GhostFX(float4 txt, float2 uv, float smooth, float up, float down, float left, float right)
			{
				float a = txt.a;
				float c1 = 1;
				float noffset = smooth;
				if (uv.y > up)      c1 = saturate(((1 + noffset) / (1 - up))*(1 - uv.y) - noffset);
				if (uv.y < 1 - down) c1 *= saturate(((1 + noffset) / (1 - down))*uv.y - noffset);
				if (uv.x > right)  c1 *= saturate(((1 + noffset) / (1 - right))*(1 - uv.x) - noffset);
				if (uv.x < 1 - left) c1 *= saturate(((1 + noffset) / (1 - left))*uv.x - noffset);
				txt.a = a*c1;
				return txt;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 NewTex_1 = tex2D(_NewTex_1, i.texcoord);
				float4 _GhostFX_1 = GhostFX(NewTex_1,i.texcoord,_GhostFX_Smooth_1,_GhostFX_ClipUp_1,_GhostFX_ClipDown_1,_GhostFX_ClipLeft_1,_GhostFX_ClipRight_1);
				float4 FinalResult = _GhostFX_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
