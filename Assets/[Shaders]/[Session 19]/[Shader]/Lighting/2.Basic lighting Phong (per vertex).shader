//Complete lighting model with phong specular calculated per vertex.

Shader "ShaderSuperb/Session19/Lighting/BasicLightingPerVertex"
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
                fixed4 light : COLOR0;
            };
 
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
 
            v2f vert(appdata_base v)
            {
                v2f o;
                // World position
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
 
                // Clip position
                o.pos = mul(UNITY_MATRIX_VP, worldPos);
 
                // Light direction
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
 
                // Normal in WorldSpace
                float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
 
                // Camera direction
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);
 
                // Compute ambient lighting
                fixed4 amb = _Ambient * _AmbColor;
 
                // Compute the diffuse lighting
                fixed4 NdotL = max(0., dot(worldNormal, lightDir) * _LightColor0);
                fixed4 dif = NdotL * _Diffuse * _LightColor0 * _DifColor;
 
                o.light = dif + amb;
 
                // Compute the specular lighting
                #if _SPEC_ON
                float3 refl = reflect(-lightDir, worldNormal);
                float RdotV = max(0., dot(refl, viewDir));
                fixed4 spec = pow(RdotV, _Shininess) * _LightColor0 * ceil(NdotL) * _SpecColor;
 
                o.light += spec;
                #endif
               
                o.uv = v.texcoord;
 
                return o;
            }
 
            sampler2D _MainTex;
 
            // Emission
            sampler2D _EmissionTex;
            fixed4 _EmiColor;
            fixed _EmiVal;
 
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv);
                c.rgb *= i.light;
 
                // Compute emission
                fixed4 emi = tex2D(_EmissionTex, i.uv).r * _EmiColor * _EmiVal;
                c.rgb += emi.rgb;
 
                return c;
            }
 
            ENDCG
        }
    }
}