
Shader "ShaderSuperb/Session15/RGBA-FX/01-FX-Blur"
{
	Properties
	{
		_MainTex1("Sprite Texture", 2D) = "white" {}
		_Blur_Intensity_1("_Blur_Intensity_1", Range(1, 16)) = 1
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

			sampler2D _MainTex1;
			float _SpriteFade;
			float _Blur_Intensity_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 Blur(float2 uv, sampler2D source, float Intensity)
			{
				float stepU = 0.00390625f * Intensity;
				float stepV = stepU;
				float4 result = float4 (0, 0, 0, 0);
				float2 texCoord = float2(0, 0);
				texCoord = uv + float2(-stepU, -stepV); result += tex2D(source, texCoord);
				texCoord = uv + float2(-stepU, 0); result += 2.0 * tex2D(source, texCoord);
				texCoord = uv + float2(-stepU, stepV); result += tex2D(source, texCoord);
				texCoord = uv + float2(0, -stepV); result += 2.0 * tex2D(source, texCoord);
				texCoord = uv; result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(0, stepV); result += 2.0 * tex2D(source, texCoord);
				texCoord = uv + float2(stepU, -stepV); result += tex2D(source, texCoord);
				texCoord = uv + float2(stepU, 0); result += 2.0* tex2D(source, texCoord);
				texCoord = uv + float2(stepU, -stepV); result += tex2D(source, texCoord);
				result = result * 0.0625;
				return result;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 _Blur_1 = Blur(i.texcoord,_MainTex1,_Blur_Intensity_1);
				float4 FinalResult = _Blur_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
