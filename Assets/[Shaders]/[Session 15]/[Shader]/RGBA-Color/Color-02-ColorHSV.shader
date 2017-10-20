
Shader "ShaderSuperb/Session15/RGBA-Color/Color-02-ColorHSV"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
		_ColorHSV_Hue_1("_ColorHSV_Hue_1", Range(0, 360)) = 180
		_ColorHSV_Saturation_1("_ColorHSV_Saturation_1", Range(0, 2)) = 1
		_ColorHSV_Brightness_1("_ColorHSV_Brightness_1", Range(0, 2)) = 1
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
			float _ColorHSV_Hue_1;
			float _ColorHSV_Saturation_1;
			float _ColorHSV_Brightness_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 ColorHSV(float4 RGBA, float HueShift, float Sat, float Val)
			{

				float4 RESULT = float4(RGBA);
				float a1 = Val*Sat;
				float a2 = HueShift*3.14159265 / 180;
				float VSU = a1*cos(a2);
				float VSW = a1*sin(a2);

				RESULT.x = (.299*Val + .701*VSU + .168*VSW)*RGBA.x
				+ (.587*Val - .587*VSU + .330*VSW)*RGBA.y
				+ (.114*Val - .114*VSU - .497*VSW)*RGBA.z;

				RESULT.y = (.299*Val - .299*VSU - .328*VSW)*RGBA.x
				+ (.587*Val + .413*VSU + .035*VSW)*RGBA.y
				+ (.114*Val - .114*VSU + .292*VSW)*RGBA.z;

				RESULT.z = (.299*Val - .3*VSU + 1.25*VSW)*RGBA.x
				+ (.587*Val - .588*VSU - 1.05*VSW)*RGBA.y
				+ (.114*Val + .886*VSU - .203*VSW)*RGBA.z;

				return RESULT;
			}
			
			float4 frag (v2f i) : COLOR
			{
				float4 NewTex_1 = tex2D(_NewTex_1, i.texcoord);
				float4 _ColorHSV_1 = ColorHSV(NewTex_1,_ColorHSV_Hue_1,_ColorHSV_Saturation_1,_ColorHSV_Brightness_1);
				float4 FinalResult = _ColorHSV_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
