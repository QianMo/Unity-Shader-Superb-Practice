Shader "ShaderSuperb/Session8/03-PhotoShop Amplify Color V2"
{
	Properties
	{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_Color ("Color", Color) = (1,0,0,1)

		//Add the Input Levels Values
		_inBlack ("Input Black", Range(0, 255)) = 0
		_inGamma ("Input Gamma", Range(0, 2)) = 1.61
		_inWhite ("Input White", Range(0, 255)) = 255
		
		//Add the Output Levels
		_outWhite ("Output White", Range(0, 255)) = 255
		_outBlack ("Output Black", Range(0, 255)) = 0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			CGPROGRAM

			#pragma vertex vert             
			#pragma fragment frag

			sampler2D _MainTex;
			float4 _Color;

			//Add these variables
			//to the CGPROGRAM
			float _inBlack;
			float _inGamma;
			float _inWhite;
			float _outWhite;
			float _outBlack;

			struct vertInput 
			{
				float4 pos : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct vertOutput 
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			float GetPixelLevel(float pixelColor)
			{
				float pixelResult;
				pixelResult = (pixelColor * 255.0);
				pixelResult = max(0, pixelResult - _inBlack);
				pixelResult = saturate(pow(pixelResult / (_inWhite - _inBlack), _inGamma));
				pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack)/255.0;	
				return pixelResult;
			}

			vertOutput vert(vertInput input) 
			{
				vertOutput o;
				o.pos = UnityObjectToClipPos(input.pos);
				o.texcoord = input.texcoord;
				return o;
			}

			float4 frag(vertOutput output) : COLOR
			{
				float4 TexColor = tex2D(_MainTex, output.texcoord);

				float adjustPixelColor_R  = GetPixelLevel(TexColor.r);
				float adjustPixelColor_G = GetPixelLevel(TexColor.g);
				float adjustPixelColor_B = GetPixelLevel(TexColor.b);

				float4 resultColor = float4(adjustPixelColor_R,adjustPixelColor_G,adjustPixelColor_B,TexColor.a) * _Color;
				
				return resultColor;
			}

			ENDCG
		}
	}
}



	