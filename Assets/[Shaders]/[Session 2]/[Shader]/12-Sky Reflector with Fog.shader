//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderSuperb/Session2/12-SkyReflection"
{
    Properties
    {
        _FogUVFactor("fogUVFactor",float) = 1.0
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            //Needed for fog variation to be compiled.
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float _FogUVFactor;

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
            struct v2f {
                half3 worldSpaceReflectVector : TEXCOORD0;
                float4 pos : SV_POSITION;

                //Used to pass fog amount around number should be a free texcoord.
                UNITY_FOG_COORDS(1)
            };

            v2f vert (a2v v)
            {
                v2f o;
                //模型空间的坐标转换为裁剪空间中坐标
                o.pos = UnityObjectToClipPos(v.vertex);
                // 世界空间中顶点坐标
                float3 worldSpaceVertexPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                // 世界空间中视图方向
                // Computes world space view direction, from object space position: 
                //函数定义 UnityCG.cginc：inline float3 UnityWorldSpaceViewDir( in float3 worldPos ){return _WorldSpaceCameraPos.xyz - worldPos;}
                float3 worldSpaceViewDir = normalize(UnityWorldSpaceViewDir(worldSpaceVertexPos));
                // 世界空间中法线方向 || world space normal
                float3 worldSpaceNormalDir = UnityObjectToWorldNormal(v.normal);
                // 世界空间反射向量 || world space reflection vector
                o.worldSpaceReflectVector = reflect(-worldSpaceViewDir, worldSpaceNormalDir);

                //Compute fog amount from clip space position.
                UNITY_TRANSFER_FOG(o,o.pos);

                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {
                // 使用世界空间反射向量采样默认的立方体贴图 || sample the default reflection cubemap, using the reflection vectorF
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldSpaceReflectVector);
                // 解码cubemap成颜色值 || decode cubemap data into actual color
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                // 
                fixed4 c = 0;
                c.rgb = skyColor;

                UNITY_APPLY_FOG(i.fogCoord *_FogUVFactor, c); 
                
                return c;
            }
            ENDCG
        }
    }
}