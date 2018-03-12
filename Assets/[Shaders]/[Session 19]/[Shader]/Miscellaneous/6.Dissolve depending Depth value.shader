// A 3D model is dissolved as it approaches the camera.

// Noise library used :
// Keijiro
// https://pastebin.com/C2iENAym

// http://www.shaderslab.com/demo-89---dissolve-depending-depth-value.html


Shader "ShaderSuperb/Session19/Miscellaneous/DepthDissolve"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}

		[Header(Dissolution)]
		_DisBegin ("Begin (The lower, the closer of the camera)", Range(0., 1.0)) = 0.
		_DisEnd ("End (Should be lower than Begin value)", Range(0., 1.0)) = 0.

		[Header(Ambient)]
		_Ambient ("Intensity", Range(0., 1.)) = 0.1
		_AmbColor ("Color", color) = (1., 1., 1., 1.)

		[Header(Diffuse)]
		_Diffuse ("Val", Range(0., 1.)) = 1.
		_DifColor ("Color", color) = (1., 1., 1., 1.)

		[Header(Specular)]
		[Toggle] _Spec("Enabled?", Float) = 0.
		_Shininess ("Shininess", Range(0.1, 10)) = 1.
		_SpecColor ("Specular color", color) = (1., 1., 1., 1.)

		[Header(Emission)]
		_EmissionTex ("Emission texture", 2D) = "gray" {}
		_EmiVal ("Intensity", float) = 0.
		[HDR]_EmiColor ("Color", color) = (1., 1., 1., 1.)
	}

	SubShader
	{
		Pass
		{
			Tags { "RenderType"="Opaque" "Queue"="Geometry" "LightMode"="ForwardBase"}

			//Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// Change "shader_feature" with "pragma_compile" if you want set this keyword from c# code
			#pragma shader_feature __ _SPEC_ON

			#include "UnityCG.cginc"

			// Change path if needed
			#include "6.ClassicNoise3D.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				float4 projPos : TEXCOORD3;
			};

			v2f vert(appdata_full v)
			{
				v2f o;
				// World position
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				// Clip position
				o.pos = mul(UNITY_MATRIX_VP, float4(o.worldPos, 1.));

				// Screen position
				o.projPos = ComputeScreenPos(o.pos);

				// Normal in WorldSpace
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				o.uv = v.texcoord;

				return o;
			}

			sampler2D _MainTex;

			fixed4 _LightColor0;
			
			// Diffuse
			fixed _Diffuse;
			fixed4 _DifColor;

			//Specular
			fixed _Shininess;
			fixed4 _SpecColor;
			
			//Ambient
			fixed _Ambient;
			fixed4 _AmbColor;

			// Emission
			sampler2D _EmissionTex;
			fixed4 _EmiColor;
			fixed _EmiVal;

			// Dissolution
			fixed _DisBegin;
			float _DisEnd;

			// Depth texture
			sampler2D _CameraDepthTexture;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, i.uv);

				// Light direction
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

				// Camera direction
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

				float3 worldNormal = normalize(i.worldNormal);

				// Compute ambient lighting
				fixed4 amb = _Ambient * _AmbColor;

				// Compute the diffuse lighting
				fixed4 NdotL = max(0., dot(worldNormal, lightDir) * _LightColor0);
				fixed4 dif = NdotL * _Diffuse * _LightColor0 * _DifColor;

				fixed4 light = dif + amb;

				// Compute the specular lighting
				#if _SPEC_ON
				float3 refl = normalize(reflect(-lightDir, worldNormal));
				float RdotV = max(0., dot(refl, viewDir));
				fixed4 spec = pow(RdotV, _Shininess) * _LightColor0 * ceil(NdotL) * _SpecColor;

				light += spec;
				#endif

				c.rgb *= light.rgb;

				// Compute emission
				fixed4 emi = tex2D(_EmissionTex, i.uv).r * _EmiColor * _EmiVal;
				c.rgb += emi.rgb;

				// Retrieve the depth value
				float depth = Linear01Depth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)).r);

				// To avoid some artefacts
				if(depth == 1.)
					discard;

				// Establish if we display the pixel or discard it
				float ind = step(depth, _DisBegin) * (1 - (depth - _DisEnd) / (_DisBegin - _DisEnd));
				if((cnoise(i.worldPos) + 1.) / 2. <= ind)
					discard;

				return c;
			}

			ENDCG
		}
	}

	// !! Needed to use the depth texture !!
	FallBack "Diffuse"
}