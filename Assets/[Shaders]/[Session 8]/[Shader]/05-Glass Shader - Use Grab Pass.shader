Shader "ShaderSuperb/Session8/05-Glass Shader - Use Grab"
{
	Properties
	{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_Colour("Colour", Color) = (1,1,1,1)

		_BumpMap("Noise text", 2D) = "bump" {}
		_Magnitude("Magnitude", Range(0,1)) = 0.05
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
		ZWrite On Lighting Off Cull Off Fog{ Mode Off } Blend One Zero

		GrabPass{  }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;

			sampler2D _MainTex;
			fixed4 _Colour;

			sampler2D _BumpMap;
			float  _Magnitude;

			struct vin_vct
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f_vct
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;

				float4 uvgrab : TEXCOORD1;
			};

			// Vertex function 
			v2f_vct vert(vin_vct v)
			{
				v2f_vct o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;

				o.texcoord = v.texcoord;
				//grab
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			// Fragment function
			half4 frag(v2f_vct i) : COLOR
			{
				half4 mainColour = tex2D(_MainTex, i.texcoord);

				half4 bump = tex2D(_BumpMap, i.texcoord);
				half2 distortion = UnpackNormal(bump).rg;

				i.uvgrab.xy += distortion * _Magnitude;

				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col * mainColour * _Colour;
			}

			ENDCG
		}
	}
}



	