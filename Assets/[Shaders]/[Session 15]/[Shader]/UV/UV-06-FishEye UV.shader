
Shader "ShaderSuperb/Session15/UV/UV-06-FishEye UV"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		FishEyeUV_Size_1("FishEyeUV_Size_1", Range(0, 0.5)) = 0.25
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
			float FishEyeUV_Size_1;
			sampler2D _NewTex_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float2 FishEyeUV(float2 uv, float size)
			{
				float2 m = float2(0.5, 0.5);
				float2 d = uv - m;
				float r = sqrt(dot(d, d));
				float power = (2.0 * 3.141592 / (2.0 * sqrt(dot(m, m)))) * (size+0.001);
				float bind = sqrt(dot(m, m));
				uv = m + normalize(d) * tan(r * power) * bind / tan(bind * power);
				return uv;
			}
			float4 frag (v2f i) : COLOR
			{
				float2 FishEyeUV_1 = FishEyeUV(i.texcoord,FishEyeUV_Size_1);
				float4 NewTex_1 = tex2D(_NewTex_1,FishEyeUV_1);
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
