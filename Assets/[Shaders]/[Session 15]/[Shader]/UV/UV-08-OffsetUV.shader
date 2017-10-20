
Shader "ShaderSuperb/Session15/UV/UV-08-OffsetUV"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		OffsetUV_X_1("OffsetUV_X_1", Range(-1, 1)) = 0
		OffsetUV_Y_1("OffsetUV_Y_1", Range(-1, 1)) = 0
		OffsetUV_ZoomX_1("OffsetUV_ZoomX_1", Range(0.1, 10)) = 1
		OffsetUV_ZoomY_1("OffsetUV_ZoomY_1", Range(0.1, 10)) = 1
		_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
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
			float OffsetUV_X_1;
			float OffsetUV_Y_1;
			float OffsetUV_ZoomX_1;
			float OffsetUV_ZoomY_1;
			sampler2D _NewTex_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float2 OffsetUV(float2 uv, float offsetx, float offsety, float zoomx, float zoomy)
			{
				uv += float2(offsetx, offsety);
				uv = fmod(uv * float2(zoomx, zoomy), 1);
				return uv;
			}

			float2 OffsetUVClamp(float2 uv, float offsetx, float offsety, float zoomx, float zoomy)
			{
				uv += float2(offsetx, offsety);
				uv = fmod(clamp(uv * float2(zoomx, zoomy), 0.0001, 0.9999), 1);
				return uv;
			}
			float4 frag (v2f i) : COLOR
			{
				float2 OffsetUV_1 = OffsetUV(i.texcoord,OffsetUV_X_1,OffsetUV_Y_1,OffsetUV_ZoomX_1,OffsetUV_ZoomY_1);
				float4 NewTex_1 = tex2D(_NewTex_1,OffsetUV_1);
				float4 FinalResult = NewTex_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
