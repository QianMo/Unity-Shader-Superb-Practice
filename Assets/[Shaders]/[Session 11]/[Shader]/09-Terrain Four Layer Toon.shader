
//http://wiki.unity3d.com/index.php/TransparentShadowCaster

Shader "ShaderSuperb/Session11/09-Terrain Four Layer Toon"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Color 1 (RGB)", 2D) = "white" {}
		_MainTex2 ("Color 2 (RGB)", 2D) = "white" {}
		_MainTex3 ("Color 3 (RGB)", 2D) = "white" {}
		_MainTex4 ("Color 4 (RGB)", 2D) = "white" {}
		_Mask ("Mixing Mask (RGBA)", 2D) = "gray" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {} 
	}

	Category 
	{
		Lighting On
		Cull Back
		Fog { Color [_AddFog] }
		Subshader 
		{
			CGPROGRAM
			#pragma surface surf ToonRamp
				
			sampler2D _Ramp;

			
			inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
			{
				#ifndef USING_DIRECTIONAL_LIGHT
				lightDir = normalize(lightDir);
				#endif
	
				half d = dot (s.Normal, lightDir)*0.5 + 0.5;

				half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
	
				half4 c;



				c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten/2);
				c.a = 0;
				return c;
			}

			sampler2D _MainTex;
			sampler2D _MainTex2;

			sampler2D _Mask;
			float4 _Color;

			struct Input 
			{			
				float4 pos : SV_POSITION;
				float2 uv_MainTex;
				float2 uv_MainTex2;

				float2 uv_Mask;
				float2 uv_Base;


				float4 diffuse : COLOR;
			};


			void surf (Input IN, inout SurfaceOutput o) 
			{
			
				// get the first three layer colors
				half4 color1 = tex2D( _MainTex, IN.uv_MainTex);
				half4 color2 = tex2D( _MainTex2, IN.uv_MainTex2);


				// get the mixing mask texture
				half4 mask = tex2D( _Mask, IN.uv_Mask.xy);
				// mix the three layers
				
				half4 color = color1 * mask.r + color2 * mask.g;

				o.Albedo = color.rgb;
				o.Alpha = color.a;
			}
			
			ENDCG 

			Blend one one

			CGPROGRAM
			#pragma surface surf ToonRamp
				
			sampler2D _Ramp;
			
			inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
			{
				#ifndef USING_DIRECTIONAL_LIGHT
				lightDir = normalize(lightDir);
				#endif
	
				half d = dot (s.Normal, lightDir)*0.5 + 0.5;

				half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
	
				half4 c;

				c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten/2);
				c.a = 0;
				return c;
			}


			sampler2D _MainTex3;
			sampler2D _MainTex4;
			sampler2D _Mask;
			float4 _Color;

			struct Input
			{			
				float4 pos : SV_POSITION;

				float2 uv_MainTex3;
				float2 uv_MainTex4;
				float2 uv_Mask;
				float2 uv_Base;


				float4 diffuse : COLOR;
			};



			void surf (Input IN, inout SurfaceOutput o) 
			{
			
				// get the first three layer colors

				half4 color3 = tex2D( _MainTex3, IN.uv_MainTex3);
				half4 color4 = tex2D( _MainTex4, IN.uv_MainTex4);

				// get the mixing mask texture
				half4 mask = tex2D( _Mask, IN.uv_Mask.xy);


				// mix the three layers
				half4 color = color3 * mask.b + color4 * mask.a;

				o.Albedo = color.rgb/2;
				o.Alpha = color.a;
			}
			
			ENDCG 
		}
	}

    // ------------------------------------------------------------------
    // Radeon 7000 / 9000
    SubShader 
    {
        Pass 
        {
            Material 
            {
                Diffuse [_Color]
                Ambient [_Color]
            } 
            Lighting On
            SetTexture [_MainTexture] 
            {
                Combine texture * primary DOUBLE, texture * primary
            }
        }
    }
}