
Shader "ShaderSuperb/Session15/RGBA-FX/06-FX-Desintegration"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
		_Desintegration_Value_1("_Desintegration_Value_1", Range(0, 1)) = 0.5448718
		_Desintegration_Speed_1("_Desintegration_Speed_1", Range(0, 1)) = 0.5
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
			float _Desintegration_Value_1;
			float _Desintegration_Speed_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float DGFXr (float2 c, float seed)
			{
				return frac(43.*sin(c.x+7.*c.y)*seed);
			}

			float DGFXn (float2 p, float seed)
			{
				float2 i = floor(p), w = p-i, j = float2 (1.,0.);
				w = w*w*(3.-w-w);
				return lerp(lerp(DGFXr(i, seed), DGFXr(i+j, seed), w.x), lerp(DGFXr(i+j.yx, seed), DGFXr(i+1., seed), w.x), w.y);
			}

			float DGFXa (float2 p, float seed)
			{
				float m = 0., f = 2.;
				for ( int i=0; i<9; i++ ){ m += DGFXn(f*p, seed)/f; f+=f; }
				return m;
			}

			float4 DesintegrationFX(float4 txt, float2 uv, float value, float seed)
			{

				float t = frac(value*0.9999);
				float4 c = smoothstep(t / 1.2, t + .1, DGFXa(3.5*uv, seed));
				c = txt*c;
				c.r = lerp(c.r, c.r*(1 - c.a), value);
				c.g = lerp(c.g, c.g*(1 - c.a), value);
				c.b = lerp(c.b, c.b*(1 - c.a), value);
				return c;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 NewTex_1 = tex2D(_NewTex_1, i.texcoord);
				float4 _Desintegration_1 = DesintegrationFX(NewTex_1,i.texcoord,_Desintegration_Value_1,_Desintegration_Speed_1);
				float4 FinalResult = _Desintegration_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
