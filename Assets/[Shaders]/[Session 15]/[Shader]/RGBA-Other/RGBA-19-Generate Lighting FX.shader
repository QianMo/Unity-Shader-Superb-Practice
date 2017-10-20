
Shader "ShaderSuperb/Session15/RGBA-Other/RGBA-19-Generate Lighting FX"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_GenerateLightning_PosX_1("_GenerateLightning_PosX_1", Range(-2, 2)) = 0.5
		_GenerateLightning_PosY_1("_GenerateLightning_PosY_1", Range(-2, 2)) = 0.5
		_GenerateLightning_Size_1("_GenerateLightning_Size_1", Range( 1, 8)) = 4
		_GenerateLightning_Number_1("_GenerateLightning_Number_1", Range(2, 16)) = 4
		_GenerateLightning_Speed_1("_GenerateLightning_Speed_1", Range( 0, 8)) = 1
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
			float _GenerateLightning_PosX_1;
			float _GenerateLightning_PosY_1;
			float _GenerateLightning_Size_1;
			float _GenerateLightning_Number_1;
			float _GenerateLightning_Speed_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float Lightning_Hash(float2 p)
			{
				float3 p2 = float3(p.xy, 1.0);
				return frac(sin(dot(p2, float3(37.1, 61.7, 12.4)))*3758.5453123);
			}

			float Lightning_noise(in float2 p)
			{
				float2 i = floor(p);
				float2 f = frac(p);
				f *= f * (1.5 - .5*f);
				return lerp(lerp(Lightning_Hash(i + float2(0., 0.)), Lightning_Hash(i + float2(1., 0.)), f.x),
					lerp(Lightning_Hash(i + float2(0., 1.)), Lightning_Hash(i + float2(1., 1.)), f.x),
					f.y);
			}

			float Lightning_fbm(float2 p)
			{
				float v = 0.0;
				v += Lightning_noise(p*1.0)*.5;
				v += Lightning_noise(p*2.)*.25;
				v += Lightning_noise(p*4.)*.125;
				v += Lightning_noise(p*8.)*.0625;
				return v;
			}

			float4 Generate_Lightning(float2 uv, float2 uvx, float posx, float posy, float size, float number, float speed, float black)
			{
				uv -= float2(posx, posy);
				uv *= size;
				uv -= float2(posx, posy);
				float rot = (uv.x*uvx.x + uv.y*uvx.y);
				float time = _Time * 20 * speed;
				float4 r = float4(0, 0, 0, 0);
				for (int i = 1; i < number; ++i)
				{
					float t = abs(.750 / ((rot + Lightning_fbm(uv + (time*5.75) / float(i)))*65.));
					r += t *0.5;
				}
				r = saturate(r);
				r.a = saturate(r.r + black);
				return r;

			}
			float4 frag (v2f i) : COLOR
			{
				float4 _GenerateLightning_1 = Generate_Lightning(i.texcoord,float2(0,1),_GenerateLightning_PosX_1,_GenerateLightning_PosY_1,_GenerateLightning_Size_1,_GenerateLightning_Number_1,_GenerateLightning_Speed_1,0);
				float4 FinalResult = _GenerateLightning_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
