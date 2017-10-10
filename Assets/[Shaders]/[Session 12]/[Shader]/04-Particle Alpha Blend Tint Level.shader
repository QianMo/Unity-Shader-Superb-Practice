
Shader "ShaderSuperb/Session12/03-Particle Alpha Blend Tint Level"
{
	Properties 
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_Level("Brightness", Float) = 1
	}

	CGINCLUDE

	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	uniform half4 _MainTex_ST;
	half4 _TintColor;
	half _Level;

	struct appdata 
	{
		float4 vertex : POSITION;
		half2 texcoord : TEXCOORD0;
		half4 color : COLOR0;
	};

	struct v2f 
	{
		float4 pos : SV_POSITION;
		half2	uv : TEXCOORD0;
		half4	color : COLOR;
	};	

	v2f vert (appdata v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);		
		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.color = v.color * _TintColor;
		return o;
	}
	
	half4 frag (v2f i) : COLOR
	{
		half4 texcol = tex2D( _MainTex, i.uv ) * i.color * _Level;
		return texcol;
	}

	ENDCG
	
	SubShader 
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off Lighting Off ZWrite Off Fog { Mode Off }

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			ENDCG
		}
	}
	Fallback Off
}

