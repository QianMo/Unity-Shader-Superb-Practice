

Shader "ShaderSuperb/Session12/05-Alpha Add Mask Tint Two Alpha"
{
	Properties 
	{
		_TintColor ("Tint Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MaskTex ("AlphaMask (R)", 2D) = "white" {}
		_Level("Brightness", Float) = 1
	}

	CGINCLUDE

	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	uniform half4 _MainTex_ST;
	uniform sampler2D _MaskTex;
	uniform half4 _MaskTex_ST;
	half4 _TintColor;
	half _Level;

	struct appdata 
	{
		float4 vertex : POSITION;
		half2 texcoord : TEXCOORD0;		
	};

	struct v2f 
	{
		float4 pos : SV_POSITION;
		half2	uv : TEXCOORD0;
		half2   uv1 : TEXCOORD1;
	};	

	v2f vert (appdata v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);		
		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.uv1 = TRANSFORM_TEX(v.texcoord, _MaskTex);		
		return o;
	}
	
	half4 frag (v2f i) : COLOR
	{
		half4 texcol = tex2D( _MainTex, i.uv ) * _TintColor;
		half alpha = tex2D( _MaskTex, i.uv1 ).r;
		texcol *= alpha * _TintColor.a;
		texcol *= _Level;
		return texcol;
	}

	ENDCG
	
	SubShader 
	{
		LOD 100
		Tags { "Queue" = "Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		Lighting Off
		Fog { Mode Off }

	    Pass 
	    {
			ZWrite Off
			AlphaTest Off
			Blend SrcAlpha One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			ENDCG
	    }
	}
	Fallback Off
}

