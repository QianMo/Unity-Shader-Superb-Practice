//The closer, the more the model is divided.
// More information :
// Unity documentation:https://docs.unity3d.com/Manual/SL-SurfaceShaderTessellation.html


Shader "ShaderSuperb/Session19/Surface shader/Tessellation"
{
	Properties {
		_Tess ("Tessellation value", Range(0, 20)) = 1
		_DistMin ("Distance min", float) = 0
		_DistMax ("Distance max", float) = 1
	}
	Subshader {
		
		Tags { "Queue"="Geometry" }

			CGPROGRAM
			#pragma surface surf Standard vertex:vert tessellate:tess
			#pragma target 4.6
			#include "UnityCG.cginc"
			#include "Tessellation.cginc"

			struct Input {
				float3 worldPos;
			};

			float _Tess;

			float _DistMin;
			float _DistMax;

			float4 tess(appdata_base v0, appdata_base v1, appdata_base v2)
			{
				return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _DistMin, _DistMax, _Tess);
			}

			void vert(inout appdata_base v ){}

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				o.Albedo = fixed4(1, 1, 1, 1);
			}

			ENDCG
	}	
}