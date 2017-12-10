// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// base on http://blog.csdn.net/baidu_26153715/article/details/45420029

Shader "ShaderSuperb/Session16/4-GlassTest"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CUBE ("CUBE Texture",CUBE)="white" {}
		_Color ("Color",Color)=(1.0,1.0,1.0,1.0)
		_AdjustColor ("1Color",Color)=(1.0,1.0,1.0,1.0)
		_Re1("Re1",Range(0.0,1.0))= 0.5
		_Re2("Re2",Range(0.0,0.04))= 0.0
		_Range("Range",Range(0.0,1.0))= 0		
	}
	SubShader
	{
		LOD 200
		Pass
		{
			Cull Back
			Blend Off
			Lighting On
			AlphaTest Off
			ZWrite On
			ZTest On
			Fog {Mode Off }
			Tags {"RenderType"="Transparent" "Queue"="Transparent" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"


			sampler2D _MainTex;
			samplerCUBE _CUBE;
			fixed3 _Color;
			fixed3 _AdjustColor;
			uniform float _Re1;
			uniform float _Re2;
			uniform fixed _Range;


			struct vertexInput
			{
				float4 vertex : POSITION;
				fixed2 tex : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				half3 nDir : NORMAL;
				float3 vDir : TEXCOORD1;
				float3 lDir : TEXCOORD2;
				float3 rDir : TEXCOORD3;
				//float2 reDir : TEXCOORD4;
			};


			
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				o.pos=UnityObjectToClipPos (v.vertex);
				o.uv=v.tex;
				o.nDir = normalize(mul(unity_WorldToObject,half4(v.normal,0)).xyz);
				o.vDir = WorldSpaceViewDir(v.vertex);
				o.lDir = WorldSpaceLightDir(v.vertex);
				o.rDir = normalize(reflect(-o.vDir,o.nDir));
				return o;
			}
			
			fixed4 frag (vertexOutput o) : SV_Target
			{
				fixed3 reflectCube = texCUBE(_CUBE,normalize(o.rDir));
				float3 re[3];
				re[0] = (refract(-o.vDir,o.nDir,_Re1));
				re[1] = (refract(-o.vDir,o.nDir,_Re1 + _Re2));
				re[2] = (refract(-o.vDir,o.nDir,_Re1 + 2.0 *_Re2));

				fixed3 reTex;
				reTex.r = texCUBE(_CUBE,re[0]).r;
				reTex.b = texCUBE(_CUBE,re[1]).g;
				reTex.g = texCUBE(_CUBE,re[2]).b;

				float fresnel = 0.55 +0.5 * (pow(clamp(1.0-dot(o.vDir,o.nDir),0.0,1.0),2));

				
				fixed4 col = pow(fixed4(lerp(reTex, reflectCube,fresnel)*_AdjustColor+_Color,1),1.1);
				
				return col;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
