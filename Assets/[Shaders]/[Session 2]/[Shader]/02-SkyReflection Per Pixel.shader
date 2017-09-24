//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderSuperb/Session2/02-SkyReflection Per Pixel"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"


            //---------------------------------
            //顶点输入结构体
            //---------------------------------
            struct a2v
            {
                float4 vertex:POSITION;//从Unity获取顶点位置
                float3 normal:NORMAL;//从Unity获取法线坐标
            };


            //---------------------------------
            //顶点输出，片元输入结构体
            //---------------------------------
            struct v2f 
            {
                float3 worldSpaceVertexPos : TEXCOORD0;
                float3 worldSpaceNormalDir : TEXCOORD1;
                float4 pos : SV_POSITION;
            };

            v2f vert (a2v v)
            {
                v2f o;
                //模型空间的坐标转换为裁剪空间中坐标
                o.pos = UnityObjectToClipPos(v.vertex);
                // 世界空间中顶点坐标
                o.worldSpaceVertexPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                // 世界空间中法线方向 || world space normal
                o.worldSpaceNormalDir = UnityObjectToWorldNormal(v.normal);
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldSpaceViewDir = normalize(UnityWorldSpaceViewDir(i.worldSpaceVertexPos));
                float3 worldSpaceReflectVector = reflect(-worldSpaceViewDir, i.worldSpaceNormalDir);
                // 使用世界空间反射向量采样默认的立方体贴图 || sample the default reflection cubemap, using the reflection vector
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldSpaceReflectVector);
                // 解码cubemap成颜色值 || decode cubemap data into actual color
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                // 
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
}