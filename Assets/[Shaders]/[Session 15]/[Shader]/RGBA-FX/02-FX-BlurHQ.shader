
Shader "ShaderSuperb/Session15/RGBA-FX/02-FX-BlurHQ"
{
	Properties
	{
		_MainTex1("Sprite Texture", 2D) = "white" {}
		_BlurHQ_Intensity_1("_BlurHQ_Intensity_1", Range(1, 16)) = 1
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
			float _BlurHQ_Intensity_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float4 BlurHQ(float2 uv, sampler2D source, float Intensity)
			{
				float step1 = 0.00390625f * Intensity * 0.5;
				float step2 = step1 * 2;
				float4 result = float4 (0, 0, 0, 0);
				float2 texCoord = float2(0, 0);
				texCoord = uv + float2(-step2, -step2); result += tex2D(source, texCoord);
				texCoord = uv + float2(-step1, -step2); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(0, -step2); result += 6.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step1, -step2); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step2, -step2); result += tex2D(source, texCoord);
				texCoord = uv + float2(-step2, -step1); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(-step1, -step1); result += 16.0 * tex2D(source, texCoord);
				texCoord = uv + float2(0, -step1); result += 24.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step1, -step1); result += 16.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step2, -step1); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(-step2, 0); result += 6.0 * tex2D(source, texCoord);
				texCoord = uv + float2(-step1, 0); result += 24.0 * tex2D(source, texCoord);
				texCoord = uv; result += 36.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step1, 0); result += 24.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step2, 0); result += 6.0 * tex2D(source, texCoord);
				texCoord = uv + float2(-step2, step1); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(-step1, step1); result += 16.0 * tex2D(source, texCoord);
				texCoord = uv + float2(0, step1); result += 24.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step1, step1); result += 16.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step2, step1); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(-step2, step2); result += tex2D(source, texCoord);
				texCoord = uv + float2(-step1, step2); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(0, step2); result += 6.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step1, step2); result += 4.0 * tex2D(source, texCoord);
				texCoord = uv + float2(step2, step2); result += tex2D(source, texCoord);
				result = result*0.00390625;
				return result;
			}
			
			float4 frag (v2f i) : COLOR
			{
				float4 _BlurHQ_1 = BlurHQ(i.texcoord,_MainTex1,_BlurHQ_Intensity_1);
				float4 FinalResult = _BlurHQ_1;
				FinalResult.rgb *= i.color.rgb;
				FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
				return FinalResult;
			}

			ENDCG
		}
	}
	Fallback "Sprites/Default"
}
