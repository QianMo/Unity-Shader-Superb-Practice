//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderSuperb/Session2/03-SkyReflection Per Pixel Normal"
{
  Properties 
    {
        // normal map texture on the material,
        // default to dummy "flat surface" normalmap
        _BumpMap("Normal Map", 2D) = "bump" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // normal map texture from shader properties
            sampler2D _BumpMap;
            uniform float4 _BumpMap_ST;
            //---------------------------------
            //顶点输入结构体
            //---------------------------------
            struct a2v
            {
                float4 vertex:POSITION;//从Unity获取顶点位置
                float3 normal:NORMAL;//从Unity获取法线坐标
                float4 tangent : TANGENT;//从Unity获取切线坐标
                float2 uv : TEXCOORD0; //从Unity获取第一组纹理坐标
            };


            //---------------------------------
            //顶点输出，片元输入结构体
            //---------------------------------
            struct v2f 
            {
                float3 worldSpaceVertexPos : TEXCOORD0;

                // these three vectors will hold a 3x3 rotation matrix
                // that transforms from tangent to world space
                half3 objectToWorldVector0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 objectToWorldVector1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 objectToWorldVector2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
                
                // texture coordinate for the normal map
                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;
            };

            v2f vert (a2v v)
            {
                v2f o;
                //模型空间的坐标转换为裁剪空间中坐标
                o.pos = UnityObjectToClipPos(v.vertex);
                // 世界空间中顶点坐标
                o.worldSpaceVertexPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                half3 wNormal = UnityObjectToWorldNormal(v.normal);
                half3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
                // compute bitangent from cross product of normal and tangent
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;

                // output the tangent space matrix
                o.objectToWorldVector0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.objectToWorldVector1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.objectToWorldVector2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.uv = TRANSFORM_TEX(v.uv,_BumpMap);
                
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {

                // sample the normal map, and decode from the Unity encoding
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                // transform normal from tangent to world space
                half3 worldSpaceNormalDir;
                worldSpaceNormalDir.x = dot(i.objectToWorldVector0, tnormal);
                worldSpaceNormalDir.y = dot(i.objectToWorldVector1, tnormal);
                worldSpaceNormalDir.z = dot(i.objectToWorldVector2, tnormal);

                float3 worldSpaceViewDir = normalize(UnityWorldSpaceViewDir(i.worldSpaceVertexPos));
                float3 worldSpaceReflectVector = reflect(-worldSpaceViewDir, worldSpaceNormalDir);
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