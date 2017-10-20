
Shader "ShaderSuperb/Session15/RGBA-FX/12-FX-PlasmaFX"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
		_PlasmaFX_Offset_1("_PlasmaFX_Offset_1", Range(0, 1)) = 0.5
		_PlasmaFX_Speed_1("_PlasmaFX_Speed_1", Range(0, 1)) = 0.5
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
			float _PlasmaFX_Offset_1;
			float _PlasmaFX_Speed_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			inline float RBFXmod(float x,float modu)
			{
				return x - floor(x * (1.0 / modu)) * modu;
			}

			float3 RBFXrainbow(float t)
			{
				t= RBFXmod(t,1.0);
				float tx = t * 8;
				float r = clamp(tx - 4.0, 0.0, 1.0) + clamp(2.0 - tx, 0.0, 1.0);
				float g = tx < 2.0 ? clamp(tx, 0.0, 1.0) : clamp(4.0 - tx, 0.0, 1.0);
				float b = tx < 4.0 ? clamp(tx - 2.0, 0.0, 1.0) : clamp(6.0 - tx, 0.0, 1.0);
				return float3(r, g, b);
			}

			float4 Plasma(float4 txt, float2 uv, float _Offset, float speed)
			{
				float _TimeX=_Time.y * speed;
				_Offset *= 8;
				float a = 1.1 + _TimeX * 2.25 + _Offset;
				float b = 0.5 + _TimeX * 1.77 + _Offset;
				float c = 8.4 + _TimeX * 1.58 + _Offset;
				float d = 610 + _TimeX * 2.03 + _Offset;
				float x1 = 2.0 * uv.x;
				float n = sin(a + x1) + sin(b - x1) + sin(c + 2.0 * uv.y) + sin(d + 5.0 * uv.y);
				n = RBFXmod(((5.0 + n) / 5.0), 1.0);
				float4 nx=txt;
				n += nx.r * 0.2 + nx.g * 0.4 + nx.b * 0.2;
				return float4(RBFXrainbow(n),txt.a);
			}
			float4 frag (v2f i) : COLOR
			{
				float4 NewTex_1 = tex2D(_NewTex_1, i.texcoord);
				float4 _PlasmaFX_1 = Plasma(NewTex_1,i.texcoord,_PlasmaFX_Offset_1,_PlasmaFX_Speed_1);
				float4 FinalResult = _PlasmaFX_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
