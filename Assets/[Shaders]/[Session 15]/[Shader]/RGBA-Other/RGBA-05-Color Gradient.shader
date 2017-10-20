
Shader "ShaderSuperb/Session15/RGBA-Other/RGBA-05-Color Gradient"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
		_ColorGradients_Color1_1("_ColorGradients_Color1_1", COLOR) = (1,0,0,1)
		_ColorGradients_Color2_1("_ColorGradients_Color2_1", COLOR) = (0,0,1,1)
		_ColorGradients_Color3_1("_ColorGradients_Color3_1", COLOR) = (0,1,0,1)
		_ColorGradients_Color4_1("_ColorGradients_Color4_1", COLOR) = (1,1,0,1)
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
			float4 _ColorGradients_Color1_1;
			float4 _ColorGradients_Color2_1;
			float4 _ColorGradients_Color3_1;
			float4 _ColorGradients_Color4_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 Color_Gradients(float4 txt, float2 uv, float4 col1, float4 col2, float4 col3, float4 col4)
			{
				float4 c1 = lerp(col1, col2, smoothstep(0., 0.33, uv.x));
				c1 = lerp(c1, col3, smoothstep(0.33, 0.66, uv.x));
				c1 = lerp(c1, col4, smoothstep(0.66, 1, uv.x));
				c1.a = txt.a;
				return c1;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 NewTex_1 = tex2D(_NewTex_1, i.texcoord);
				float4 _ColorGradients_1 = Color_Gradients(NewTex_1,i.texcoord,_ColorGradients_Color1_1,_ColorGradients_Color2_1,_ColorGradients_Color3_1,_ColorGradients_Color4_1);
				float4 FinalResult = _ColorGradients_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
