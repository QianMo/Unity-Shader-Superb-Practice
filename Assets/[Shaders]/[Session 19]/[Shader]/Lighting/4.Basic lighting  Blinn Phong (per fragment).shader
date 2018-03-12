//Complete lighting model with Blinn Phong specular model calculated in the fragment shader.

Shader "ShaderSuperb/Session19/Lighting/PerFragment/Blinn-Phong"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}

		[Header(Ambient)]
		_Ambient ("Intensity", Range(0., 1.)) = 0.1
		_AmbColor ("Color", color) = (1., 1., 1., 1.)

		[Header(Diffuse)]
		_Diffuse ("Val", Range(0., 1.)) = 1.
		_DifColor ("Color", color) = (1., 1., 1., 1.)

		[Header(Specular)]
		[Toggle] _Spec("Enabled?", Float) = 0.
		_Shininess ("Shininess", Range(0.1, 100)) = 1.
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
			Tags { "RenderType"="Opaque" "Queue"="Geometry" "LightMode"="ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// Change "shader_feature" with "pragma_compile" if you want set this keyword from c# code
			#pragma shader_feature __ _SPEC_ON

			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				// World position
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				// Clip position
				o.pos = mul(UNITY_MATRIX_VP, float4(o.worldPos, 1.));

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

				// If enabled, compute the specular lighting (Blinn-phong)
				#if _SPEC_ON
				float3 HalfVector = normalize(lightDir + viewDir);
				float NdotH = max(0., dot(worldNormal, HalfVector));
				fixed4 spec = pow(NdotH, _Shininess) * _LightColor0 * _SpecColor;

				light += spec;
				#endif

				c.rgb *= light.rgb;

				// Compute emission
				fixed4 emi = tex2D(_EmissionTex, i.uv).r * _EmiColor * _EmiVal;
				c.rgb += emi.rgb;
				
				return c;
			}

			ENDCG
		}
	}
}