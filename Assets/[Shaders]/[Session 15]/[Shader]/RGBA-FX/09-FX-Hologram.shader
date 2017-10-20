
Shader "ShaderSuperb/Session15/RGBA-FX/09-FX-Hologram"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_SourceNewTex_1("_SourceNewTex_1(RGB)", 2D) = "white" { }
		_Hologram_Value_1("_Hologram_Value_1", Range(-1, 1)) = 1
		_Hologram_Speed_1("_Hologram_Speed_1", Range(0, 4)) = 1
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
			sampler2D _SourceNewTex_1;
			float _Hologram_Value_1;
			float _Hologram_Speed_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			inline float Holo1mod(float x,float modu)
			{
				return x - floor(x * (1.0 / modu)) * modu;
			}

			inline float Holo1noise(sampler2D source,float2 p)
			{
				float _TimeX = _Time.y;
				float sample = tex2D(source,float2(.2,0.2*cos(_TimeX))*_TimeX*8. + p*1.).x;
				sample *= sample;
				return sample;
			}

			inline float Holo1onOff(float a, float b, float c)
			{
				float _TimeX = _Time.y;
				return step(c, sin(_TimeX + a*cos(_TimeX*b)));
			}

			float4 Hologram(float2 uv, sampler2D source, float value, float speed)
			{
				float alpha = tex2D(source, uv).a;
				float _TimeX = _Time.y * speed;
				float2 look = uv;
				float window = 1. / (1. + 20.*(look.y - Holo1mod(_TimeX / 4., 1.))*(look.y - Holo1mod(_TimeX / 4., 1.)));
				look.x = look.x + sin(look.y*30. + _TimeX) / (50.*value)*Holo1onOff(4., 4., .3)*(1. + cos(_TimeX*80.))*window;
				float vShift = .4*Holo1onOff(2., 3., .9)*(sin(_TimeX)*sin(_TimeX*20.) + (0.5 + 0.1*sin(_TimeX*20.)*cos(_TimeX)));
				look.y = Holo1mod(look.y + vShift, 1.);
				float4 video = float4(0, 0, 0, 0);
				float4 videox = tex2D(source, look);
				video.r = tex2D(source, look - float2(.05, 0.)*Holo1onOff(2., 1.5, .9)).r;
				video.g = videox.g;
				video.b = tex2D(source, look + float2(.05, 0.)*Holo1onOff(2., 1.5, .9)).b;
				video.a = videox.a;
				video = video;
				float vigAmt = 3. + .3*sin(_TimeX + 5.*cos(_TimeX*5.));
				float vignette = (1. - vigAmt*(uv.y - .5)*(uv.y - .5))*(1. - vigAmt*(uv.x - .5)*(uv.x - .5));
				float noi = Holo1noise(source,uv*float2(0.5, 1.) + float2(6., 3.))*value * 3;
				float y = Holo1mod(uv.y*4. + _TimeX / 2. + sin(_TimeX + sin(_TimeX*0.63)), 1.);
				float start = .5;
				float end = .6;
				float inside = step(start, y) - step(end, y);
				float fact = (y - start) / (end - start)*inside;
				float f1 = (1. - fact) * inside;
				video += f1*noi;
				video += Holo1noise(source,uv*2.) / 2.;
				video.r *= vignette;
				video *= (12. + Holo1mod(uv.y*30. + _TimeX, 1.)) / 13.;
				video.a = video.a + (frac(sin(dot(uv.xy*_TimeX, float2(12.9898, 78.233))) * 43758.5453))*.5;
				video.a = (video.a*.3)*alpha*vignette * 2;
				video.a *=1.2;
				return video;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 _Hologram_1 = Hologram(i.texcoord,_SourceNewTex_1,_Hologram_Value_1,_Hologram_Speed_1);
				float4 FinalResult = _Hologram_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
