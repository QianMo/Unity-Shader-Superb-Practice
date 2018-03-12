// Use the normals to compute a "rim effect"
// Model comes from :
// https://free3d.com/3d-model/dolphin-91252.html


Shader "ShaderSuperb/Session19/Surface shader/Rim effect" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _RimValue ("Rim value", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
 
        CGPROGRAM
        #pragma surface surf Lambert alpha
 
        sampler2D _MainTex;
        fixed _RimValue;
 
        struct Input {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldNormal;
        };
 
        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            float3 normal = normalize(IN.worldNormal);
            float3 dir = normalize(IN.viewDir);
            float val = 1 - (abs(dot(dir, normal)));
            float rim = val * val * _RimValue;
            o.Alpha = c.a * rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}