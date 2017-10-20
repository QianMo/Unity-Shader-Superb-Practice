
Shader "ShaderSuperb/Session15/UV/UV-14-Rotation UV"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		RotationUV_Rotation_1("RotationUV_Rotation_1", Range(-360, 360)) = 0
		RotationUV_Rotation_PosX_1("RotationUV_Rotation_PosX_1", Range(-1, 2)) = 0.5
		RotationUV_Rotation_PosY_1("RotationUV_Rotation_PosY_1", Range(-1, 2)) =0.5
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
			float RotationUV_Rotation_1;
			float RotationUV_Rotation_PosX_1;
			float RotationUV_Rotation_PosY_1;
			sampler2D _NewTex_1;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}


			float2 RotationUV(float2 uv, float rot, float posx, float posy)
			{
				uv = uv - float2(posx, posy);
				float angle = rot * 0.01744444;
				float sinX = sin(angle);
				float cosX = cos(angle);
				float2x2 rotationMatrix = float2x2(cosX, -sinX, sinX, cosX);
				uv = mul(uv, rotationMatrix) + float2(posx, posy);
				return uv;
			}
			float4 frag (v2f i) : COLOR
			{
				float2 RotationUV_1 = RotationUV(i.texcoord,RotationUV_Rotation_1,RotationUV_Rotation_PosX_1,RotationUV_Rotation_PosY_1);
				float4 NewTex_1 = tex2D(_NewTex_1,RotationUV_1);
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
