
//Simple Physical Shader was written by Ryan Gatts 2014
//Based on concepts pioneered by Double Fine, Disney, Unreal Engine, Jim Blinn, Sean Murphy, Josh Ols, and Nicholas Francis.

Shader "ShaderSuperb/Session22/SimplePhysicalShaderCoat"
{
	Properties
	{
		_MainColor("Main Color", Color) = (0.5, 0.5, 0.5, 0.5)
		_MainTex("Main Color Texture", 2D) = "white" {}
		_Smoothness("Smoothness", Range(1, 12)) = 2.0
		_SmoothMap("Smoothness Map", 2D) = "white" {} 
		_Metallicity("Metallicity", Range(0, 1)) = 0 
		_MetalMap("Metallicity Map", 2D) = "white" {}
		_Wrap("Light Wrap", float) = 0.25
		_NormalMap("Normal Map", 2D) = "bump" {}
		_BumpDepth("Bump Depth", Range(0.1, 4.0)) = 1
		_Coat("Clear Coat", Range(0, 1)) = 0
		_CoatMap("Clear Coat Map", 2D) = "white" {}
		_CoatSmooth("Coat Smoothness", Range(1, 12)) = 12
		_RSRM("RSRM", 2D) = "gray" {}
		
	}
	
	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 3.0
				#pragma multi_compile_fwdadd_fullshadows
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				//user defined
				uniform sampler2D _MainTex;
				uniform sampler2D _NormalMap;
				uniform sampler2D _SmoothMap; 
				uniform sampler2D _MetalMap;
				uniform sampler2D _CoatMap;
				uniform sampler2D _RSRM;
				uniform float4	_MainTex_ST;
				uniform float4	_NormalMap_ST;
				uniform float4	_SmoothMap_ST;
				uniform float4	_MetalMap_ST;
				uniform float4	_CoatMap_ST;
				uniform float4 	_MainColor;
				uniform float 	_Smoothness;
				uniform float	_Metallicity;
				uniform float	_Wrap;
				uniform float	_Coat;
				uniform float	_CoatSmooth;
				uniform float   _BumpDepth;
				
				//unity defined
				uniform float4 	_LightColor0;
				
				//base input struct
				struct vertexInput
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 tangent : TANGENT;
				};
				
				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float4 tex : TEXCOORD0;
					float4 posWorld : TEXCOORD1;
					float3 normalWorld : TEXCOORD2;
					float3 tangentWorld : TEXCOORD3;
					float3 binormalWorld : TEXCOORD4;
					
					LIGHTING_COORDS(5,6)
				};
				
				//vertex function
				vertexOutput vert (vertexInput v)
				{
					vertexOutput o;
					
					float4x4 modelMatrix 		= unity_ObjectToWorld;
					float4x4 modelMatrixInverse = unity_WorldToObject;
					
					o.normalWorld = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
					o.tangentWorld = normalize(mul(unity_ObjectToWorld, half4(half3(v.tangent.xyz), 0)));
					o.binormalWorld = normalize(cross (o.normalWorld, o.tangentWorld) * v.tangent.w);
					
					o.posWorld = mul(unity_ObjectToWorld, v.vertex);
					o.pos = UnityObjectToClipPos(v.vertex);
					o.tex = v.texcoord;
					
					TRANSFER_VERTEX_TO_FRAGMENT(o); // for shadows
					
					return o;
					
				}
				
				//take a -1 to 1 range and fit it 0 to 1
				float clamp01 (float toBeNormalized) 
				{
					return toBeNormalized * 0.5 + 0.5;
				}
				
				float3 calculateAmbientReflection( float3 rsrm , float texM ) 
				{
					float3 amb  = UNITY_LIGHTMODEL_AMBIENT.xyz;
					return  float3 (1.5 * rsrm * amb + amb * 0.5 * texM);
				}
					
				//fragment function
				float4 frag(vertexOutput i) : COLOR
				{
					float shadAtten = LIGHT_ATTENUATION(i);
					
					float4 tex	= tex2D(_MainTex,   i.tex.xy * _MainTex_ST.xy   + _MainTex_ST.zw);
					tex  = tex  * _MainColor;
					float  texS	= tex2D(_SmoothMap, i.tex.xy * _SmoothMap_ST.xy + _SmoothMap_ST.zw);
					texS = texS * _Smoothness; 
					float  texM	= tex2D(_MetalMap,  i.tex.xy * _MetalMap_ST.xy  + _MetalMap_ST.zw);
					texM = texM * _Metallicity;
					float4 texN	= tex2D(_NormalMap, i.tex.xy * _NormalMap_ST.xy + _NormalMap_ST.zw);
					float nDepth = 8 / (_BumpDepth * 8);
					float4 texC1= tex2D(_CoatMap,	i.tex.xy * _CoatMap_ST.xy 	+ _CoatMap_ST.zw);
					float  texC = Luminance(texC1.rgb) * _Coat * texC1.a;
					
					//Unpack Normal
					half3 localCoords = half3(2.0 * texN.ag - float2(1.0, 1.0), 0.0);
					localCoords.z = nDepth;
					
					//normal transpose matrix
					float3x3 local2WorldTranspose = float3x3
					(
						i.tangentWorld,
						i.binormalWorld,
						i.normalWorld
					);
					
					//Calculate normal direction
					float3 normalDir = normalize( mul( localCoords, local2WorldTranspose));
					
					float3 N = normalize( normalDir);
					float3 V = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz);
					float3 fragmentToLight = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float  distanceToLight = length(fragmentToLight);
					float  atten = pow(2, -0.1 * distanceToLight * distanceToLight) * _WorldSpaceLightPos0.w + 1 - _WorldSpaceLightPos0.w; // (-0.1x^2)^2 for pointlights 1 for dirlights
					float3 L = (normalize(fragmentToLight)) * _WorldSpaceLightPos0.w + normalize(_WorldSpaceLightPos0.xyz) * (1 - _WorldSpaceLightPos0.w);
					float3 H = normalize( V + L );
					float3 worldReflect = reflect(V,N);
					
					//lighting
					float NdotL 	= dot(N,L);
					float NdotV 	= 1 - max(0.0, dot(N,V));
					float NdotH 	= clamp(dot(N,H), 0, 1);
					float VdotL 	= clamp01(dot(V,L));
					float wrap 		= clamp(_Wrap, -0.25, 1.0);
					
					float4 texdesat = dot(tex.rgb, float3(0.3, 0.59, 0.11));
					
					float3 difftex	= lerp(tex, float4(0,0,0,0), pow(texM, 1)).xyz;
					float3 spectex	= lerp(texdesat, tex, texM).xyz;
					
					VdotL 			= pow(VdotL, 0.85);
					float smooth 	= 4 * pow(1.8, texS - 2) + 1.5;
					float smoothCoat= 4 * pow(1.8, _CoatSmooth - 2) + 1.5;
					float rim		= texM + (pow(NdotV, 1 + texS / 6)) * (1 - texM);
					float coatrim	= pow(NdotV, 1 + _CoatSmooth / 6);
					float bellclamp = (1 / (1 + pow(0.65 * acos(dot(N,L)), 16)));
					
					float3 rsrm 	= tex2D(_RSRM, float2((1 - (texS - 1) * 0.09), 1 - clamp01(worldReflect.y)));
					float3 rsrmDiff = tex2D(_RSRM, float2(1, N.y));
					float3 rsrmCoat = tex2D(_RSRM, float2((1 - (_CoatSmooth - 1) * 0.09), 1 - clamp01(worldReflect.y)));
					float3 ambReflect     = calculateAmbientReflection(rsrm, texM);
					float3 ambReflectDiff = calculateAmbientReflection(rsrmDiff, texM);
					float3 ambReflectCoat = calculateAmbientReflection(rsrmCoat, 0); 
					
					
					float3 spec = NdotH;
					spec =  pow (spec, smooth * VdotL) * log(smooth*(VdotL+1)) * bellclamp * texS * (1 / texS) * 0.5;
					spec *= shadAtten * atten * spectex.xyz * _LightColor0.rgb * (2+texM) * spectex.xyz;
					spec += ambReflect * spectex.rgb * rim * 2 - texC * 0.05;
					
					float3 coat = NdotH;
					coat = pow (coat, 4 * smoothCoat * VdotL) * log(smoothCoat*(VdotL+1)) * bellclamp * smoothCoat * (1 / smoothCoat) * 0.5;
					coat *= shadAtten * atten * texC * _LightColor0.rgb;
					coat += ambReflectCoat * texC * coatrim * 2;
					
					float3 diff = max(0, (pow(max(0, (NdotL * (1 - wrap) + wrap)), (2 * wrap + 1))));
					diff *= lerp(shadAtten, 1, wrap) * atten * difftex.xyz * _LightColor0.rgb * 2 * _LightColor0.rgb * difftex.xyz;
					diff += ambReflect * difftex.xyz * rim + ambReflectDiff * 2 * difftex.xyz;
					
					return float4 (atan(clamp(spec + diff + coat, 0, 2)), 1); //this is used to round off values above one and give better color reproduction in bright scenes
				}
			
			ENDCG
		}
		Pass
		{
			Tags{ "LightMode" = "ForwardAdd"}
			Fog {Mode Off}
			Blend One One
			CGPROGRAM
			
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 3.0
				#include "UnityCG.cginc"
				
				//user defined
				uniform sampler2D _MainTex;
				uniform sampler2D _NormalMap;
				uniform sampler2D _SmoothMap; 
				uniform sampler2D _MetalMap;
				uniform sampler2D _CoatMap;
				uniform float4	_MainTex_ST;
				uniform float4	_NormalMap_ST;
				uniform float4	_SmoothMap_ST;
				uniform float4	_MetalMap_ST;
				uniform float4	_CoatMap_ST;
				uniform float4 	_MainColor;
				uniform float 	_Smoothness;
				uniform float	_Wrap;
				uniform float	_Coat;
				uniform float	_CoatSmooth;
				uniform float   _BumpDepth;
				uniform float	_Metallicity;
				
				//unity defined
				uniform float4 	_LightColor0;
				
				//base input struct
				struct vertexInput
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 tangent : TANGENT;
				};
				
				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float4 tex : TEXCOORD0;
					float4 posWorld : TEXCOORD1;
					float3 normalWorld : TEXCOORD2;
					float3 tangentWorld : TEXCOORD3;
					float3 binormalWorld : TEXCOORD4;
				};
				
				//vertex function
				vertexOutput vert (vertexInput v)
				{
					vertexOutput o;
					
					float4x4 modelMatrix = unity_ObjectToWorld;
					float4x4 modelMatrixInverse = unity_WorldToObject;
					
					o.normalWorld = normalize( mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
					o.tangentWorld = normalize(mul(unity_ObjectToWorld, half4(half3(v.tangent.xyz), 0)));
					o.binormalWorld = normalize(cross (o.normalWorld, o.tangentWorld) * v.tangent.w);
					
					o.posWorld = mul(unity_ObjectToWorld, v.vertex);
					o.pos = UnityObjectToClipPos(v.vertex);
					o.tex = v.texcoord;
					
					return o;
				}
				
				//fragment function
				float4 frag(vertexOutput i) : COLOR
				{
					float4 tex	= tex2D(_MainTex,   i.tex.xy * _MainTex_ST.xy   + _MainTex_ST.zw);
					tex = tex * _MainColor;
					float4 texS	= tex2D(_SmoothMap, i.tex.xy * _SmoothMap_ST.xy + _SmoothMap_ST.zw);
					texS = texS * _Smoothness; 
					float4 texM	= tex2D(_MetalMap,  i.tex.xy * _MetalMap_ST.xy  + _MetalMap_ST.zw);
					texM = texM * _Metallicity;
					float4 texN	= tex2D(_NormalMap, i.tex.xy * _NormalMap_ST.xy + _NormalMap_ST.zw);
					float nDepth = 8 / (_BumpDepth * 8);
					float4 texC1= tex2D(_CoatMap,	i.tex.xy * _CoatMap_ST.xy 	+ _CoatMap_ST.zw);
					float  texC = Luminance(texC1.rgb) * _Coat * texC1.a;
					
					//Unpack Normal
					half3 localCoords = half3(2.0 * texN.ag - float2(1.0, 1.0), 0.0);
					localCoords.z = nDepth;
					
					//normal transpose matrix
					float3x3 local2WorldTranspose = float3x3
					(
						i.tangentWorld,
						i.binormalWorld,
						i.normalWorld
					);
					
					//Calculate normal direction
					float3 normalDir = normalize( mul( localCoords, local2WorldTranspose));
					
					float3 N = normalize(normalDir);
					float3 V = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
					float3 fragmentToLight = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float  distanceToLight = length(fragmentToLight);
					float  atten = pow(2, -0.1 * distanceToLight * distanceToLight) * _WorldSpaceLightPos0.w + 1 - _WorldSpaceLightPos0.w;
					float3 L = normalize(fragmentToLight) * _WorldSpaceLightPos0.w + normalize(_WorldSpaceLightPos0.xyz) * (1 - _WorldSpaceLightPos0.w);
					float3 H = normalize(V + L);
					
					//lighting
					float NdotL 	= dot(N,L);
					float NdotH 	= clamp(dot(N,H), 0, 1);
					float VdotL 	= dot(V,L) * 0.5 + 0.5;
					float wrap 		= clamp(_Wrap, -0.25, 1.0);
					
					float4 texdesat = dot(tex.rgb, float3(0.3, 0.59, 0.11));
					
					float3 difftex	= lerp(tex, float4(0,0,0,0), pow(texM, 1)).xyz;
					float3 spectex	= lerp(texdesat, tex, texM).xyz;
					
					VdotL 			= pow(VdotL, 0.85);
					float smooth 	= 4 * pow(1.8, texS - 2) + 1.5;
					float smoothCoat= 4 * pow(1.8, _CoatSmooth - 2) + 1.5;
					float bellclamp = (1 / (1 + pow(0.65 * acos(dot(N,L)), 16)));
					
					float3 spec = NdotH;
					spec =  pow(spec, smooth * VdotL) * log(smooth * (VdotL + 1)) * bellclamp;
					spec *= atten * spectex.xyz * _LightColor0.rgb * (2 + _Metallicity) * spectex.xyz;
					spec -= texC * 0.05;
					
					float3 coat = NdotH;
					coat = pow (coat, smoothCoat * VdotL) * log(smoothCoat*(VdotL+1)) * bellclamp * smoothCoat * (1 / smoothCoat) * 0.5;
					coat *= atten * texC * _LightColor0.rgb;
					
					float3 diff = max(0, (pow(max(0, (NdotL * (1 - wrap) + wrap)), (2 * wrap + 1))));
					diff *= atten * difftex.xyz * _LightColor0.rgb * 2 * difftex.xyz;
					
					return float4 (atan(clamp(spec + diff + coat, 0, 2)), 1); //this is used to round off values above one and give better color reproduction in bright scenes
					
				}
			
			ENDCG
		}
		
	}
	Fallback "Diffuse"
}